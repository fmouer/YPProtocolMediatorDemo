//
//  YPLoginViewController.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/5/9.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "YPLoginViewController.h"
#import "YPProtocolMediator.h"
#import "YPUserCenterDelegate.h"
#import "YPUserCenterPort.h"
#import "NSObject+Protocol.h"
#import "YPLoginModuleConfig.h"
#import "YPAppModuleConfigManager.h"

@interface YPLoginViewController ()<YPUserCenterDelegate>

@property (nonatomic, strong) UIButton *loginAccountButton;
@property (nonatomic, strong) YPLoginModuleConfig *moduleConfig; // 组件配置model

@end

@implementation YPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"账号登录";
    [self.view addSubview:self.loginAccountButton];
    
    [self configLoginButton];
    [self registerUserCenterDelegateEvent];
    
    self.loginAccountButton.frame = CGRectMake(100, 260, self.view.frame.size.width - 200, 50);
}


- (void)loginAccountButtonEvent:(UIButton *)button {
    if ([[button titleForState:UIControlStateNormal] isEqualToString:self.moduleConfig.loginButtonTitle]) {
        [_loginAccountButton setTitle:@"登录中..." forState:UIControlStateNormal];
        
        // 执行登录操作, 如果不确定参数是否为空，请用 YPParamVaule(value) 传参
        [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_Login:password:) args:@"1851558", YPParamVaule(@"123456"), nil];
    } else {
        [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_CleanAccount)];
    }
}

#pragma mark - 多方式实现组件间通信
- (void)configLoginButton {
    // 方式一，通过 port_excuteSelector 方法通信，即使@selector 为声明编译也不会报错
    NSString *uid = [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_Uid)];
    // 以下方式会出现警告
//    [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_Uid1)];
    
    
    // 方式二，通过直接调用方法通信，但是如果 port_Uid 方法未声明，编译会报错
    [YPMediatorPort(YPUserCenterPort) port_Uid];
    // 以下方式会报错
//    [YPMediatorPort(YPUserCenterPort) port_Uid1];
    
    if (uid) {
        [_loginAccountButton setTitle:self.moduleConfig.quitLoginButtonTitle forState:UIControlStateNormal];
    }
}

#pragma mark - YPUserCenterDelegate 通过 block 方式实现
- (void)registerUserCenterDelegateEvent {
    // YPUserCenterDelegate 登录状态通过 block 回调
    __weak typeof(self) weakSelf = self;
    [self yp_addDelegateSelector:@selector(userCenter:loginStatus:) paramBlock:^(YPParams *params) {
        id target = params[0];
        id target0 = [params objectAtIndex:0];
        NSNumber *status = [params objectAtIndex:1];
        NSLog(@"YPLoginViewController target %@ , target0 %@, status is %@",target, target0, status);
        
        if ([status boolValue]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.loginAccountButton setTitle:self.moduleConfig.loginButtonTitle forState:UIControlStateNormal];
        }
    } forProtocol:@protocol(YPUserCenterDelegate)];

}

#pragma mark - getter

- (YPLoginModuleConfig *)moduleConfig {
    if (!_moduleConfig) {
        // 从 YPAppModuleConfigManager 中获取到组件中的配置
        _moduleConfig = [[YPAppModuleConfigManager sharedManager] parseModuleConfigClass:[YPLoginModuleConfig class]];
    }
    return _moduleConfig;
}

- (UIButton *)loginAccountButton {
    if (!_loginAccountButton) {
        _loginAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginAccountButton setTitle:self.moduleConfig.loginButtonTitle forState:UIControlStateNormal];
        [_loginAccountButton addTarget:self action:@selector(loginAccountButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginAccountButton;
}



- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
