//
//  YPHomePageViewController.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/5/9.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "YPHomePageViewController.h"
#import "YPLoginPort.h"
#import "YPProtocolMediator.h"
#import "NSObject+Protocol.h"
#import "YPUserCenterDelegate.h"
#import "YPLoginViewController.h"

@interface YPHomePageViewController ()<YPUserCenterDelegate>

@property (nonatomic, strong) UIButton *loginAccountButton;

@end

@implementation YPHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"首页";
    
    YPMediatorBind(self, YPUserCenterDelegate);
    
    [self.view addSubview:self.loginAccountButton];
    
    self.loginAccountButton.frame = CGRectMake(50, 200, self.view.frame.size.width - 100, 50);
}

- (UIButton *)loginAccountButton {
    if (!_loginAccountButton) {
        _loginAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginAccountButton setTitle:@"未登录，请跳转到登录页面" forState:UIControlStateNormal];
        [_loginAccountButton addTarget:self action:@selector(loginAccountButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginAccountButton;
}


- (void)loginAccountButtonEvent:(UIButton *)button {
    
    UIViewController * loginViewController = [YPMediatorPort(YPLoginPort) port_excuteSelector:@selector(port_loginViewController)];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(BOOL)status {
    if (status) {
        [_loginAccountButton setTitle:@"您已登录" forState:UIControlStateNormal];
    } else {
        [_loginAccountButton setTitle:@"未登录，请跳转到登录页面" forState:UIControlStateNormal];
    }
}

@end
