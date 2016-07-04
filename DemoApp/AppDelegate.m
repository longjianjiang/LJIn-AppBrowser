//
//  AppDelegate.m
//  DemoApp
//
//  Created by longjianjiang on 6/28/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#define UMAppKey            @"573c10ad67e58ef295002be9"
#define WeChatAppId         @"wx6915e3832b613cf3"
#define WeChatAppSecret     @"599e1531e27ab3da7c38cb0eafe4b5f2"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UMSocialData setAppKey:UMAppKey];
    [UMSocialWechatHandler setWXAppId:WeChatAppId appSecret:WeChatAppSecret url:@"https://www.longjianjiang.com"];

    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

@end
