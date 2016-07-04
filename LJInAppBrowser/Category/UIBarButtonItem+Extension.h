//
//  UIBarButtonItem+Extension.h
//  LJWeibo
//
//  Created by 龙建 蒋 on 16/1/29.
//  Copyright © 2016年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage;
@end
