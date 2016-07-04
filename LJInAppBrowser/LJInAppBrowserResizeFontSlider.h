//
//  LJInAppBrowserResizeFontSlider.h
//  DemoApp
//
//  Created by longjianjiang on 7/2/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJInAppBrowserResizeFontSlider;
@protocol LJInAppBrowserResizeFontSliderDelegate <NSObject>

@optional
- (void)inAppBrowserResizeFontSlider:(LJInAppBrowserResizeFontSlider *)slider didChangeFontSize:(NSString *)percent;
@end

@interface LJInAppBrowserResizeFontSlider : UIView

+ (instancetype)inAppBrowserResizeFontSlider;

@property (nonatomic,weak) id<LJInAppBrowserResizeFontSliderDelegate> delegate;

@end
