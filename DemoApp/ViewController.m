//
//  ViewController.m
//  DemoApp
//
//  Created by longjianjiang on 6/28/16.
//  Copyright © 2016 Jiang. All rights reserved.
//

#import "ViewController.h"
#import "LJInAppBrowserController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    self.view.backgroundColor = [UIColor orangeColor];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LJInAppBrowserController *browser = [[LJInAppBrowserController alloc] initWithInAppBrowserControllerStyle:LJInAppBrowserControllerStyleWhite UrlStr:@"http://www.baidu.com"];
    browser.loadingProgressColor = [UIColor orangeColor];
    browser.websiteLabelColor = [UIColor purpleColor];
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
