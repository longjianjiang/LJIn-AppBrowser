//
//  UIButton+Extension.h
//  DemoApp
//
//  Created by longjianjiang on 6/29/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
+(UIButton *)buttonBackWithImage:(UIImage *)image buttontitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
