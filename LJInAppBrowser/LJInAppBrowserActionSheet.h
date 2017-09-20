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

- (instancetype)initWithInAppBrowserActionSheetTitle:(NSString *)title fullURL:(NSString *)fullURL;

@property (nonatomic,weak) id<LJInAppBrowserActionSheetDelegate> delegate;

@end
