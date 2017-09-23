//
//  LJInAppBrowserActionSheet.m
//  DemoApp
//
//  Created by longjianjiang on 7/1/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "LJInAppBrowserActionSheet.h"
#import "UIView+Extension.h"

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ShareViewHeight 180
#define LJSrcName(file) [LJInAppBrowserBundleName stringByAppendingPathComponent:file]
#define ToolItemCount 4
static  NSString * LJInAppBrowserBundleName = @"LJInAppBrowser.bundle";

@interface LJInAppBrowserActionSheet ()

@property (nonatomic,copy) NSString *fullURL;
@property (nonatomic,copy) NSString *title;


@property (nonatomic,strong) UIView *maskingView;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIScrollView *toolItemView;
@property (nonatomic,strong) UIButton *cancelBtn;
@end


@implementation LJInAppBrowserActionSheet

#pragma mark life cycle
- (instancetype)initWithInAppBrowserActionSheetTitle:(NSString *)title fullURL:(NSString *)fullURL{
    if (self = [super init]) {
        _title = title;
        _fullURL = fullURL;
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self createContentView];
    }
    return self;
}

- (void)createContentView {
   
    [self addSubview:self.maskingView];
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.toolItemView];
    [self.contentView addSubview:self.cancelBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, kScreenHeight-ShareViewHeight, kScreenWidth, ShareViewHeight);
    }];
}

- (NSString *)getTitleAndSetImageWithToolItem:(UIButton *)itemBtn {
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
- (void)addToolItems {
    CGFloat itemWidth  = 50;
    CGFloat itemHeight = 50;
    CGFloat pading = 20;//(_toolItemView.width-itemWidth*4)/5;
    for (int i=0; i<ToolItemCount; i++) {
        UIButton * itemBtn = [[UIButton alloc] initWithFrame:CGRectMake((itemWidth+pading)*i+pading, 15, itemWidth, itemHeight)];
        itemBtn.tag = i;
        NSString *itemName =  [self getTitleAndSetImageWithToolItem:itemBtn];
        [itemBtn addTarget:self action:@selector(toolItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_toolItemView addSubview:itemBtn];
        
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemBtn.left, itemBtn.bottom+5, itemWidth, 30)];
        itemLabel.text = itemName;
        itemLabel.numberOfLines = 0;
        itemLabel.font = [UIFont systemFontOfSize:12];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        [_toolItemView addSubview:itemLabel];
    }
    _toolItemView.contentSize = CGSizeMake((itemWidth+pading)*4+pading, 0);

}

#pragma mark event response
- (void)toolItemClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:self.fullURL];
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
            NSURL *url = [NSURL URLWithString:self.fullURL];
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
        _contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, ShareViewHeight);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
    
}
#pragma mark getter and setter
- (UIView *)maskingView {
    if (!_maskingView) {
        _maskingView = [[UIView alloc] initWithFrame:self.bounds];
        _maskingView.backgroundColor = [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:0.2];
        [_maskingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)]];
    }
    return _maskingView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, ShareViewHeight)];
        _contentView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    }
    return _contentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _titleLabel.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        _titleLabel.text = [NSString stringWithFormat:@"此网页由 %@ 提供", _title];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIScrollView *)toolItemView {
    if (!_toolItemView) {
        _toolItemView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth, 106)];
        _toolItemView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        _toolItemView.showsVerticalScrollIndicator = NO;
        [self addToolItems];
    }
    return _toolItemView;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolItemView.frame), kScreenWidth, 44)];
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        [_cancelBtn addTarget:self action:@selector(dismissShareView) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _cancelBtn;
}
@end
