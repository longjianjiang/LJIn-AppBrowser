//
//  LJInAppBrowserActionSheet.m
//  DemoApp
//
//  Created by longjianjiang on 7/1/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "LJInAppBrowserActionSheet.h"
#import "UIView+Extension.h"
#import "UMSocial.h"
#import "LJInAppBrowserController.h"
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ShareViewHeight 280
#define LJSrcName(file) [LJInAppBrowserBundleName stringByAppendingPathComponent:file]
static  NSString * LJInAppBrowserBundleName = @"LJInAppBrowser.bundle";

@interface LJInAppBrowserActionSheet ()

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) UIImage *image;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) LJInAppBrowserController *controller;
@property (nonatomic,copy) NSString *fullUrl;


@property (nonatomic,strong) UIView *maskingView;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIScrollView *shareItemView;
@property (nonatomic,strong) UIScrollView *toolItemView;
@property (nonatomic,strong) UIView *separateLine;
@property (nonatomic,strong) UIButton *cancelBtn;
@end

@implementation LJInAppBrowserActionSheet
+ (instancetype)inAppBrowserActionSheetWithPresentedViewController:(UIViewController *)controller items:(NSArray *)items title:(NSString *)title image:(UIImage *)image urlResource:(NSString *)url
{
    LJInAppBrowserActionSheet *view = [[LJInAppBrowserActionSheet alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    view.title = title;
    view.url = url;
    view.image = image;
    view.items = items;
    view.controller = (LJInAppBrowserController *)controller;
    view.fullUrl = view.controller.fullUrl;
    
    [view createContentView];
    
    return view;
}

- (void)createContentView
{
   
    [self addSubview:self.maskingView];
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.shareItemView];
    [self.contentView addSubview:self.separateLine];
    [self.contentView addSubview:self.toolItemView];
    [self.contentView addSubview:self.cancelBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        _maskingView.alpha = 0.3;
        _contentView.frame = CGRectMake(0, kScreenHeight-ShareViewHeight, kScreenWidth, ShareViewHeight);
    }];
}

-(NSString *)getTitleAndSetImageWithShareItem:(UIButton *)itemBtn{
    NSString *itemTitle = @"";
    NSString *itemImage = @"";
    NSString *type = _items[itemBtn.tag];
    if([type isEqualToString:UMShareToWechatSession])
    {
        itemTitle = @"微信好友";
        itemImage = LJSrcName(@"share_img_weixin");
    }
    else if([type isEqualToString:UMShareToWechatTimeline])
    {
        itemTitle = @"朋友圈";
        itemImage = LJSrcName(@"share_img_friends");
    }
    else{
        NSLog(@"其他设备自行添加");
    }
    
    [itemBtn setImage:[UIImage imageNamed:itemImage] forState:UIControlStateNormal];
    
    return itemTitle;
}
- (NSString *)getTitleAndSetImageWithToolItem:(UIButton *)itemBtn
{
    NSString *itemTitle = @"";
    NSString *itemImage = @"";
    switch (itemBtn.tag) {
        case 0:
            itemImage = LJSrcName(@"more_icon_link");
            itemTitle = @"复制链接";
            break;
        case 1:
            itemImage = LJSrcName(@"more_icon_change_size");
            itemTitle = @"调整字体";
            break;
        case 2:
            itemImage = LJSrcName(@"more_icon_safari");
            itemTitle = @"用Safari打开";
            break;
        case 3:
            itemImage = LJSrcName(@"more_icon_refresh");
            itemTitle = @"刷新";
            break;
        default:
            break;
    }
    [itemBtn setImage:[UIImage imageNamed:itemImage] forState:UIControlStateNormal];
    
    return itemTitle;
}
- (void)addToolItems
{
    CGFloat itemWidth  = 50;
    CGFloat itemHeight = 50;
    CGFloat pading = 20;//(_toolItemView.width-itemWidth*4)/5;
    for (int i=0; i<4; i++) {
        UIButton * itemBtn = [[UIButton alloc] initWithFrame:CGRectMake((itemWidth+pading)*i+pading, 15, itemWidth, itemHeight)];
        itemBtn.tag = i;
        NSString *itemName =  [self getTitleAndSetImageWithToolItem:itemBtn];
        [itemBtn addTarget:self action:@selector(toolItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolItemView addSubview:itemBtn];
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemBtn.left, itemBtn.bottom+5, itemWidth, 20)];
        itemLabel.text = itemName;
        itemLabel.numberOfLines = 0;
        itemLabel.font = [UIFont systemFontOfSize:12];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        [_toolItemView addSubview:itemLabel];
    }
    _toolItemView.contentSize = CGSizeMake((itemWidth+pading)*4+pading, 0);

}
- (void)addShareItems
{
    if (_items.count) {
        CGFloat itemWidth  = 50;
        CGFloat itemHeight = 50;
        CGFloat pading = 20;//_items.count<5 ? (_shareItemView.width-itemWidth*_items.count)/(_items.count+1) : 30;
        for (int i=0; i<_items.count; i++) {
            UIButton * itemBtn = [[UIButton alloc] initWithFrame:CGRectMake((itemWidth+pading)*i+pading, 15, itemWidth, itemHeight)];
            itemBtn.tag = i;
            NSString *itemName =  [self getTitleAndSetImageWithShareItem:itemBtn];
            [itemBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_shareItemView addSubview:itemBtn];
            
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemBtn.left, itemBtn.bottom+5, itemWidth, 20)];
            itemLabel.numberOfLines = 0;
            itemLabel.text = itemName;
            itemLabel.font = [UIFont systemFontOfSize:12];
            itemLabel.textAlignment = NSTextAlignmentCenter;
            [_shareItemView addSubview:itemLabel];
        }
        _shareItemView.contentSize = CGSizeMake((itemWidth+pading)*_items.count+pading, 0);
    }
}
#pragma mark event response
-(void)shareItemClick:(UIButton *)btn{
    NSInteger index = btn.tag;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[_items[index]] content:_title image:_image location:nil urlResource:nil presentedController:_controller completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
        }
    }];
}
- (void)toolItemClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.fullUrl];
            [self dismissShareView];
        }
            break;
        case 1:{
            [self dismissShareView];
            if ([self.delegate respondsToSelector:@selector(inAppBrowserActionSheet:didSelectToolItemWithItemTag:)]) {
                [self.delegate inAppBrowserActionSheet:self didSelectToolItemWithItemTag:btn.tag];
            }
        }
            break;
        case 2:{
            NSURL *url = [NSURL URLWithString:self.fullUrl];
            [[UIApplication sharedApplication] openURL:url];
            [self dismissShareView];
        }
            break;
        case 3:{
            if ([self.delegate respondsToSelector:@selector(inAppBrowserActionSheet:didSelectToolItemWithItemTag:)]) {
                [self.delegate inAppBrowserActionSheet:self didSelectToolItemWithItemTag:btn.tag];
            }
            [self dismissShareView];
        }
            break;
            
        default:
            break;
    }
}
-(void)dismissShareView{
    
    [UIView animateWithDuration:0.3 animations:^{
        _maskingView.alpha = 0.0;
        _contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, ShareViewHeight);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
    
}
#pragma mark getter and setter
- (UIView *)maskingView
{
    if (!_maskingView) {
        _maskingView = [[UIView alloc] initWithFrame:self.bounds];
        _maskingView.backgroundColor = [UIColor clearColor];
        [_maskingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)]];
    }
    return _maskingView;
}
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, ShareViewHeight)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _titleLabel.backgroundColor = [UIColor grayColor];
        _titleLabel.text = @"  分享到";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UIScrollView *)shareItemView
{
    if (!_shareItemView) {
        _shareItemView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth, 100)];
        _shareItemView.backgroundColor = [UIColor grayColor];
        _shareItemView.layer.masksToBounds = YES;
        _shareItemView.showsVerticalScrollIndicator = NO;
        [self addShareItems];
    }
    return _shareItemView;
}
- (UIView *)separateLine
{
    if (!_separateLine) {
        _separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shareItemView.frame), kScreenWidth, 1)];
        _separateLine.backgroundColor = [UIColor orangeColor];
    }
    return _separateLine;
}
- (UIScrollView *)toolItemView
{
    if (!_toolItemView) {
        _toolItemView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.separateLine.frame), kScreenWidth, 100)];
        _toolItemView.backgroundColor = [UIColor grayColor];
        _toolItemView.layer.masksToBounds = YES;
        _toolItemView.showsVerticalScrollIndicator = NO;
        [self addToolItems];
    }
    return _toolItemView;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolItemView.frame), kScreenWidth, 50)];
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}
@end
