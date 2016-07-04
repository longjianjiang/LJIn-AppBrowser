//
//  UIBarButtonItem+Extension.m
//  LJWeibo
//
//  Created by 龙建 蒋 on 16/1/29.
//  Copyright © 2016年 Jiang. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
/**
 *  自定义一个创建按钮作为导航栏按钮的方法，因为位置是在left或者right，所以不需要手动设置位置
 *
 *  @param target           谁去处理事件
 *  @param action           点击触发的事件
 *  @param image            普通图片
 *  @param highlightedImage 高亮图片
 */
+ (instancetype)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage
{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    [item setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    item.size = item.currentBackgroundImage.size;
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    return barItem;
}
@end
