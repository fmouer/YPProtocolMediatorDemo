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

@interface YPLoginViewController ()<YPUserCenterDelegate>

@property (nonatomic, strong) UIButton *loginAccountButton;

@end

@implementation YPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"账号登录";
    [self.view addSubview:self.loginAccountButton];
    
    // 方式一，通过 port_excuteSelector 方法通信，即使@selector 为声明编译也不会报错
    NSString *uid = [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_Uid)];
    // 以下方式会出现警告
//    [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_Uid1)];

    
    // 方式二，通过直接调用方法通信，但是如果 port_Uid 方法未声明，编译会报错
    [YPMediatorPort(YPUserCenterPort) port_Uid];

    // 以下方式会报错
//    [YPMediatorPort(YPUserCenterPort) port_Uid1];
    
    

    if (uid) {
        [_loginAccountButton setTitle:@"退出账号" forState:UIControlStateNormal];
    }
    
    
    __weak typeof(self) weakSelf = self;
    [self yp_addDelegateSelector:@selector(userCenter:loginStatus:) paramBlock:^(YPParams *params) {
        id target = params[0];
        id target0 = [params objectAtIndex:0];
        NSNumber *status = [params objectAtIndex:1];
        NSLog(@"YPLoginViewController target %@ , target0 %@, status is %@",target, target0, status);
        
        if ([status boolValue]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.loginAccountButton setTitle:@"请登录账号" forState:UIControlStateNormal];
        }
    } forProtocol:@protocol(YPUserCenterDelegate)];
    
    self.loginAccountButton.frame = CGRectMake(100, 260, self.view.frame.size.width - 200, 50);
}

- (UIButton *)loginAccountButton {
    if (!_loginAccountButton) {
        _loginAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginAccountButton setTitle:@"请登录账号" forState:UIControlStateNormal];
        [_loginAccountButton addTarget:self action:@selector(loginAccountButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginAccountButton;
}

- (void)loginAccountButtonEvent:(UIButton *)button {
    if ([[button titleForState:UIControlStateNormal] isEqualToString:@"请登录账号"]) {
        [_loginAccountButton setTitle:@"登录中..." forState:UIControlStateNormal];
        
        // 执行登录操作, 如果不确定参数是否为空，请用 YPParamVaule(value) 传参
        [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_Login:password:) args:@"1851558", YPParamVaule(@"123456"), nil];
    } else {
        [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_CleanAccount)];
    }
}



//- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(float)status {
//
//}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
}
@end
