//
//  ViewController.m
//  DemoApp
//
//  Created by longjianjiang on 6/28/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "ViewController.h"
#import "LJInAppBrowserController.h"
#import "UINavigationBar+Awesome.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setNavColor];
}
-(void)setNavColor{
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor grayColor]];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        
        self.navigationController.navigationBar.translucent = YES;
        
        
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    LJInAppBrowserController *browser = [[LJInAppBrowserController alloc] init];
    browser.loadingProgressColor = [UIColor orangeColor];
    browser.urlStr = @"http://www.baidu.com";
    [self.navigationController pushViewController:browser animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
