//
//  LJInAppBrowserController.m
//  DemoApp
//
//  Created by longjianjiang on 6/28/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "LJInAppBrowserController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "UIBarButtonItem+Extension.h"
#import "UIButton+Extension.h"
#import "LJInAppBrowserActionSheet.h"
#import "UMSocial.h"
#import "LJInAppBrowserResizeFontSlider.h"

#define LJSrcName(file) [LJInAppBrowserBundleName stringByAppendingPathComponent:file]

@interface LJInAppBrowserController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,UIScrollViewDelegate,LJInAppBrowserActionSheetDelegate,LJInAppBrowserResizeFontSliderDelegate>


@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NJKWebViewProgressView *progressView;
@property (nonatomic,strong) NJKWebViewProgress *progressProxy;

@property (nonatomic,strong) UILabel *websiteLabel;

@property (nonatomic,assign) int scale;
@property (nonatomic,copy) NSString *websiteName;
@end

@implementation LJInAppBrowserController

NSString *const LJInAppBrowserBundleName = @"LJInAppBrowser.bundle";

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];

    [self.view addSubview:self.webView];
    [self.view addSubview:self.websiteLabel];

    [self loadURL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view sendSubviewToBack:self.websiteLabel];
    
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.progressView removeFromSuperview];
}

#pragma mark NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = self.webView.scrollView.contentOffset.y;
    if (y < -30) {
        [self.view bringSubviewToFront:self.websiteLabel];
    }else{
        [self.view sendSubviewToBack:self.websiteLabel];
    }
}

#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    self.websiteName = [self getDomainFromURL:webView.request.URL.absoluteString];
    self.fullUrl = webView.request.URL.absoluteString;
    self.websiteLabel.text = [NSString stringWithFormat:@"网页由 %@ 提供",self.websiteName];
    
    self.scale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scaleKey"] intValue];
    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",self.scale];
    [_webView stringByEvaluatingJavaScriptFromString:str1];
}
#pragma mark LJInAppBrowserActionSheetDelegate
- (void)inAppBrowserActionSheet:(LJInAppBrowserActionSheet *)actionsheet didSelectToolItemWithItemTag:(NSInteger)tag
{
    switch (tag) {
        case 1:{
            LJInAppBrowserResizeFontSlider *sliderView = [LJInAppBrowserResizeFontSlider inAppBrowserResizeFontSlider];
            sliderView.delegate = self;
            [[UIApplication sharedApplication].keyWindow addSubview:sliderView];
        }
            break;
        case 3:
            [self.webView reload];
            break;
        default:
            break;
    }
}
#pragma mark LJInAppBrowserResizeFontSliderDelegate
- (void)inAppBrowserResizeFontSlider:(LJInAppBrowserResizeFontSlider *)slider didChangeFontSize:(NSString *)percent
{
    //90 ,100, 110, 120, 130
    int scale = 100;
    switch ([percent integerValue]) {
        case 1:
            scale = 90;
            break;
        case 2:
            scale = 100;
            break;
        case 3:
            scale = 110;
            break;
        case 4:
            scale = 120;
            break;
        case 5:
            scale = 130;
            break;
        case 6:
            scale = 130;
            break;
        default:
            break;
    }
    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",scale];
    [_webView stringByEvaluatingJavaScriptFromString:str1];
    [[NSUserDefaults standardUserDefaults] setObject:@(scale) forKey:@"scaleKey"];
}
#pragma mark getter and setter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _webView.delegate = self.progressProxy;
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.contentMode = UIViewContentModeRedraw;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}
- (NJKWebViewProgress *)progressProxy
{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.progressDelegate = self;
        _progressProxy.webViewProxyDelegate = self;
    }
    return _progressProxy;
}
- (NJKWebViewProgressView *)progressView
{
    if (!_progressView) {
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.progressView.progressBarView.backgroundColor = self.loadingProgressColor;
    }
    return _progressView;
}
- (UILabel *)websiteLabel
{
    if (!_websiteLabel) {
        _websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44)];
        _websiteLabel.font = [UIFont systemFontOfSize:15];
        _websiteLabel.textColor = [UIColor redColor];
        _websiteLabel.textAlignment = NSTextAlignmentCenter;
        _websiteLabel.text = @"www.longjianjiang.com";
    }
    return _websiteLabel;
}
#pragma mark event response
- (void)itemClick
{
    LJInAppBrowserActionSheet *actionSheet = [LJInAppBrowserActionSheet inAppBrowserActionSheetWithPresentedViewController:self items:@[UMShareToWechatSession,UMShareToWechatTimeline] title:@"longjianjiang.com" image:nil urlResource:nil];
    actionSheet.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
}

-(void)clickedbackBtn:(UIButton*)btn{
    if (self.webView.canGoBack) {
        [self setupLeftNavigationBarBtn];
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickedcloseBtn:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark private method
- (NSString *)getDomainFromURL:(NSString *)url
{
    NSRange range1 = [url rangeOfString:@"://"];
    url = [url substringFromIndex:range1.location + range1.length];
    NSRange range2 = [url rangeOfString:@"/"];
    url = [url substringToIndex:range2.location];
    return url;
}
- (void)loadURL
{
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:req];
}

-(void)setupLeftNavigationBarBtn{
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    
    UIButton *backBtn = [UIButton buttonBackWithImage:[UIImage imageNamed:LJSrcName(@"backBtn")] buttontitle:@"返回" target:self action:@selector(clickedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [customView addSubview:backBtn];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(clickedcloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(38, 0, 44, 44);
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [customView addSubview:closeBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
}

-(void)setupNavigationItem
{
    self.scale = 100;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(itemClick) image:LJSrcName(@"navigationbar_more") highlightedImage:LJSrcName(@"navigationbar_more_highlighted")];
    
    UIButton *backBtn = [UIButton buttonBackWithImage:[UIImage imageNamed:LJSrcName(@"backBtn")] buttontitle:@"返回" target:self action:@selector(clickedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
@end
