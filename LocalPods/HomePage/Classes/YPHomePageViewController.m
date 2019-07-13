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
#import "YPHomePageModuleConfig.h"
#import "YPAppModuleConfigManager.h"

@interface YPHomePageViewController ()<YPUserCenterDelegate>

@property (nonatomic, strong) UIButton *loginAccountButton;
@property (nonatomic, strong) YPHomePageModuleConfig *moduleConfig; // 组件配置model

@end

@implementation YPHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 绑定 self 和 YPUserCenterDelegate
    YPMediatorBind(self, YPUserCenterDelegate);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"首页";
    
    
    [self.view addSubview:self.loginAccountButton];
    
    self.loginAccountButton.frame = CGRectMake(50, 200, self.view.frame.size.width - 100, 50);
}

- (void)loginAccountButtonEvent:(UIButton *)button {
    UIViewController * loginViewController = [YPMediatorPort(YPLoginPort) port_excuteSelector:@selector(port_loginViewController)];
    [self.navigationController pushViewController:loginViewController animated:YES];
}


#pragma mark - YPUserCenterDelegate
// 需先进行 YPMediatorBind(self, YPUserCenterDelegate);
- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(BOOL)status {
    if (status) {
        [_loginAccountButton setTitle:self.moduleConfig.quitLoginPageButtonTitle  forState:UIControlStateNormal];
    } else {
        [_loginAccountButton setTitle:self.moduleConfig.loginPageButtonTitle forState:UIControlStateNormal];
    }
}


#pragma mark - getter

- (UIButton *)loginAccountButton {
    if (!_loginAccountButton) {
        _loginAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginAccountButton setTitle:self.moduleConfig.loginPageButtonTitle forState:UIControlStateNormal];
        [_loginAccountButton addTarget:self action:@selector(loginAccountButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginAccountButton;
}


- (YPHomePageModuleConfig *)moduleConfig {
    if (!_moduleConfig) {
        // 从 YPAppModuleConfigManager 中获取到组件中的配置
        _moduleConfig = [[YPAppModuleConfigManager sharedManager] parseModuleConfigClass:[YPHomePageModuleConfig class]];
    }
    return _moduleConfig;
}

@end
