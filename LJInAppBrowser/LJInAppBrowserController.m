//
//  LJInAppBrowserController.m
//  DemoApp
//
//  Created by longjianjiang on 6/28/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "LJInAppBrowserController.h"
#import "UIView+Extension.h"
#import "LJInAppBrowserActionSheet.h"
#import "LJInAppBrowserResizeFontSlider.h"
#import <WebKit/WebKit.h>

#define LJSrcName(file) [LJInAppBrowserBundleName stringByAppendingPathComponent:file]

@interface LJInAppBrowserController ()<UIScrollViewDelegate,LJInAppBrowserActionSheetDelegate,LJInAppBrowserResizeFontSliderDelegate>

@property (nonatomic,strong) WKWebView *wkWebview;
@property (nonatomic,strong) UIProgressView *myProgressView;
@property (nonatomic,strong) UIColor *navigationItemTitleColor;
@property (nonatomic,strong) UILabel *websiteLabel;

@property (nonatomic,copy) NSString *backBtnName;
@property (nonatomic,copy) NSString *moreBtnName;

@property (nonatomic,assign) int scale;
@end

@implementation LJInAppBrowserController

NSString *const LJInAppBrowserBundleName = @"LJInAppBrowser.bundle";

#pragma mark life cycle
- (instancetype)initWithInAppBrowserControllerStyle:(LJInAppBrowserControllerStyle)style UrlStr:(NSString *)urlStr {
    if (self = [super init]) {
        _style = style;
        if (_style == LJInAppBrowserControllerStyleGray) {
            self.backBtnName = @"navigationbar_back_withtext_white";
            self.moreBtnName = @"navigationbar_more_white";
            self.navigationItemTitleColor = [UIColor whiteColor];
        } else {
            self.backBtnName = @"navigationbar_back_withtext_gray";
            self.moreBtnName = @"navigationbar_more_gray";
            self.navigationItemTitleColor = [UIColor grayColor];
        }
        _urlStr = urlStr;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _style = LJInAppBrowserControllerStyleWhite;
        _navigationItemTitleColor = [UIColor whiteColor];
        _backBtnName = @"navigationbar_back_withtext_white";
        _moreBtnName = @"navigationbar_more_white";
        _loadingProgressColor = [UIColor blueColor];
    }
    return self;
}

-(void)setupNavigationItem {
    self.scale = 100;
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    [item setBackgroundImage:[UIImage imageNamed:LJSrcName(_moreBtnName)] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:LJSrcName(_moreBtnName)] forState:UIControlStateHighlighted];
    item.size = item.currentBackgroundImage.size;
    [item addTarget:self action:@selector(itemClick) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];

    UIButton *backBtn = [self buttonBackWithImage:[UIImage imageNamed:LJSrcName(_backBtnName)] buttontitle:@"返回" target:self action:@selector(clickedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)setupTitleAndProgressView {
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    
    
    self.myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    self.myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.myProgressView.tintColor = self.loadingProgressColor;
    self.myProgressView.trackTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.myProgressView];
    
    [self.wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebview addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)loadURL {
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [self.wkWebview loadRequest:req];
}

- (void)setupSubview {
    [self.view addSubview:self.wkWebview];
    [[self.wkWebview.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.wkWebview.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:64] setActive:YES];
    [[self.wkWebview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.wkWebview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    
    [self.view addSubview:self.websiteLabel];
    
    [self setupTitleAndProgressView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupNavigationItem];
    
    [self setupSubview];
   
    [self loadURL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view sendSubviewToBack:self.websiteLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.myProgressView removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.wkWebview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebview removeObserver:self forKeyPath:@"title"];
    [self.wkWebview removeObserver:self forKeyPath:@"URL"];
}

- (void)dealloc {
    NSLog(@"i am dealloc");
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.wkWebview) {
            [self.myProgressView setAlpha:1.0f];
            [self.myProgressView setProgress:self.wkWebview.estimatedProgress animated:YES];
            if(self.wkWebview.estimatedProgress >=1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.myProgressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.myProgressView setProgress:0.0f animated:NO];
                }];
                
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.wkWebview) {
            self.title = self.wkWebview.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    
    if ([keyPath isEqualToString:@"URL"]) {
        if (object == self.wkWebview) {
            NSString *website = [self getDomainFromURL:[self.wkWebview.URL absoluteString]];
            self.websiteLabel.text = [NSString stringWithFormat:@"此网页由 %@ 提供", website];
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = self.wkWebview.scrollView.contentOffset.y;
    if (y < -30) {
        [self.view bringSubviewToFront:self.websiteLabel];
    }else{
        [self.view sendSubviewToBack:self.websiteLabel];
    }
    
}

#pragma mark UIWebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView;
//{
//    self.websiteName = [self getDomainFromURL:webView.request.URL.absoluteString];
//    self.fullUrl = webView.request.URL.absoluteString;
//    self.websiteLabel.text = [NSString stringWithFormat:@"网页由 %@ 提供",self.websiteName];
//    
//    self.scale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scaleKey"] intValue];
//    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",self.scale];
//    [_webView stringByEvaluatingJavaScriptFromString:str1];
//}

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
            [self.wkWebview reload];
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
//    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",scale];
//    [_webView stringByEvaluatingJavaScriptFromString:str1];
//    [[NSUserDefaults standardUserDefaults] setObject:@(scale) forKey:@"scaleKey"];
}
#pragma mark getter and setter
- (WKWebView *)wkWebview {
    if (!_wkWebview) {
        _wkWebview = [WKWebView new];
        _wkWebview.scrollView.delegate = self;
        _wkWebview.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _wkWebview;
}
- (UILabel *)websiteLabel {
    if (!_websiteLabel) {
        _websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44)];
        _websiteLabel.font = [UIFont systemFontOfSize:15];
        _websiteLabel.textColor = [UIColor redColor];
        _websiteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _websiteLabel;
}
#pragma mark event response
- (void)share {
    UIActivityViewController *acVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"安利一下",_urlStr] applicationActivities:nil];
    [self presentViewController:acVC animated:YES completion:nil];
}
- (void)itemClick {
    LJInAppBrowserActionSheet *actionSheet = [LJInAppBrowserActionSheet inAppBrowserActionSheetWithPresentedViewController:self items:@[] title:@"longjianjiang.com" image:nil urlResource:nil];
    actionSheet.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
}

-(void)clickedbackBtn:(UIButton*)btn {
    if (self.wkWebview.canGoBack) {
        [self setupLeftNavigationBarBtn];
        [self.wkWebview goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickedcloseBtn:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark private method
- (NSString *)getDomainFromURL:(NSString *)url {
    NSRange range1 = [url rangeOfString:@"://"];
    url = [url substringFromIndex:range1.location + range1.length];
    NSRange range2 = [url rangeOfString:@"/"];
    url = [url substringToIndex:range2.location];
    return url;
}

-(void)setupLeftNavigationBarBtn {
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    
    UIButton *backBtn = [self buttonBackWithImage:[UIImage imageNamed:LJSrcName(_backBtnName)] buttontitle:@"返回" target:self action:@selector(clickedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [customView addSubview:backBtn];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickedcloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(44, 0, 44, 44);
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [customView addSubview:closeBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
}
- (UIButton *)buttonBackWithImage:(UIImage *)image buttontitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:self.navigationItemTitleColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return btn;
}
@end
