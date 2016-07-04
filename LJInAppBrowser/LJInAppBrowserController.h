//
//  LJInAppBrowserController.h
//  DemoApp
//
//  Created by longjianjiang on 6/28/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LJInAppBrowserController : UIViewController

/**
 *  字符串形式的URL
 */
@property (nonatomic,copy)NSString* urlStr;

/**
 *  加载进度条的颜色
 */
@property (nonatomic,strong)UIColor* loadingProgressColor;
/**
 *  当前页面的URL
 */
@property (nonatomic,copy) NSString *fullUrl;

@end
