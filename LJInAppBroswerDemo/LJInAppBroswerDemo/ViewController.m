//
//  ViewController.m
//  LJInAppBroswerDemo
//
//  Created by longjianjiang on 2017/9/23.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ViewController.h"
#import "LJInAppBrowserController.h"

@interface ViewController ()
@property (nonatomic,strong) UILabel *msgLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LJInAppBroswer";
    
    [self.view addSubview:self.msgLabel];
    [[self.msgLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.msgLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LJInAppBrowserController *broswer = [[LJInAppBrowserController alloc] initWithInAppBrowserControllerStyle:LJInAppBrowserControllerStyleWhite UrlStr:@"https://www.baidu.com"];
    broswer.loadingProgressColor = [UIColor orangeColor];
    broswer.websiteLabelColor = [UIColor redColor];
    [self.navigationController pushViewController:broswer animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter and setter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [UILabel new];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.text = @"点击屏幕进入浏览器";
        _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _msgLabel;
}
@end
