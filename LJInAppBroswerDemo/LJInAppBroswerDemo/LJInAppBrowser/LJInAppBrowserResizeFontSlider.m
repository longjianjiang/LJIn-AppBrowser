//
//  LJInAppBrowserResizeFontSlider.m
//  DemoApp
//
//  Created by longjianjiang on 7/2/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "LJInAppBrowserResizeFontSlider.h"
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ShareViewHeight 100
#define LJSrcName(file) [LJInAppBrowserBundleName stringByAppendingPathComponent:file]

static  NSString * LJInAppBrowserBundleName = @"LJInAppBrowser.bundle";
@interface LJInAppBrowserResizeFontSlider()

@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,assign) float num;
@end

@implementation LJInAppBrowserResizeFontSlider

+ (instancetype)inAppBrowserResizeFontSlider
{
    LJInAppBrowserResizeFontSlider *sliderView = [[LJInAppBrowserResizeFontSlider alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [sliderView setupContentView];
    return sliderView;
}

- (void)setupContentView
{
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.backgroundView];
    [self.contentView addSubview:self.slider];
    
    int scale = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scaleKey"] intValue];
    self.num = [self getNumWithScale:scale];
    [self.slider setValue:self.num];
    
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, kScreenHeight-ShareViewHeight, kScreenWidth, ShareViewHeight);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, ShareViewHeight);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (float)getNumWithScale:(int)scale
{
    float num = 0.0;
    switch (scale) {
        case 90:
            num = 1.0;
            break;
        case 100:
            num = 2.0;
            break;
        case 110:
            num = 3.0;
            break;
        case 120:
            num = 4.0;
            break;
        case 130:
            num = 5.0;
            break;
        default:
            break;
    }
    return num;
}
#pragma mark event response
- (void)valueChanged:(UISlider *)sender
{
    NSString *tempStr = [self numberFormat:sender.value];
    [sender setValue:tempStr.floatValue];
    
    if ([self.delegate respondsToSelector:@selector(inAppBrowserResizeFontSlider:didChangeFontSize:)]) {
        [self.delegate inAppBrowserResizeFontSlider:self didChangeFontSize:tempStr];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    CGPoint p = [sender locationInView:_slider];
    float tempFloat = (p.x - 25) / (kScreenWidth - 45) * 5 + 1;
    NSString *tempStr = [self numberFormat:tempFloat];
    [_slider setValue:tempStr.floatValue];
    
    if ([self.delegate respondsToSelector:@selector(inAppBrowserResizeFontSlider:didChangeFontSize:)]) {
        [self.delegate inAppBrowserResizeFontSlider:self didChangeFontSize:tempStr];
    }
}

- (NSString *)numberFormat:(float)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}
#pragma mark getter and setter
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, ShareViewHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 37, kScreenWidth - 40, 100)];
        _slider.minimumValue = 1;
        _slider.maximumValue = 5;
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        
        //添加点击手势和滑块滑动事件响应
        [_slider addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventValueChanged];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_slider addGestureRecognizer:tap];
        [_slider setValue:2.0];
    }
    return _slider;
}
- (UIImageView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, kScreenWidth - 45, 100)];
        UIImage *img = [UIImage imageNamed:LJSrcName(@"settingFontBackground")];
        _backgroundView.image = img;
    }
    return _backgroundView;
}
@end
