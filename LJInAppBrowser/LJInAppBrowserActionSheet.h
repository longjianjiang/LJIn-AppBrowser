//
//  LJInAppBrowserActionSheet.h
//  DemoApp
//
//  Created by longjianjiang on 7/1/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJInAppBrowserActionSheet;
@protocol LJInAppBrowserActionSheetDelegate <NSObject>

@optional
- (void)inAppBrowserActionSheet:(LJInAppBrowserActionSheet *)actionsheet didSelectToolItemWithItemTag:(NSInteger)tag;
@end

@interface LJInAppBrowserActionSheet : UIView
+ (instancetype)inAppBrowserActionSheetWithPresentedViewController:(UIViewController *)controller items:(NSArray *)items title:(NSString *)title image:(UIImage *)image urlResource:(NSString *)url;
@property (nonatomic,weak) id<LJInAppBrowserActionSheetDelegate> delegate;

@end
