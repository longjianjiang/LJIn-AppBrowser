//
//  LJInAppBrowserController.h
//  DemoApp
//
//  Created by longjianjiang on 6/28/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LJInAppBrowserControllerStyle) {
    LJInAppBrowserControllerStyleWhite,
    LJInAppBrowserControllerStyleGray,
};

@interface LJInAppBrowserController : UIViewController

- (instancetype)initWithInAppBrowserControllerStyle:(LJInAppBrowserControllerStyle)style UrlStr:(NSString *)urlStr;
@property (nonatomic,assign) LJInAppBrowserControllerStyle style; /// 默认是白色
/**
 *  字符串形式的URL
 */
@property (nonatomic,copy)NSString* urlStr;

/**
 *  加载进度条的颜色
 */
@property (nonatomic,strong)UIColor* loadingProgressColor; /// 默认是蓝色
/**
 *  当前页面的URL
 */
@property (nonatomic,copy) NSString *fullUrl;
@end
