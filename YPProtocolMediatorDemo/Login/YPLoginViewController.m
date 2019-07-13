//
//  YPLoginViewController.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/5/9.
//  Copyright © 2019 xiaopeng. All rights reserved.
//

#import "YPLoginViewController.h"
#import "YPProtocolMediator.h"
#import "YPUserCenterDelegate.h"
#import "YPUserCenterPort.h"
#import "NSObject+Protocol.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface YPLoginViewController ()<YPUserCenterDelegate>

@property (nonatomic, strong) UIButton *loginAccountButton;

@end

@implementation YPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"账号登录";
    [self.view addSubview:self.loginAccountButton];
    

    if ([YPMediatorPort(YPUserCenterPort) yp_excuteSelector:@selector(excuteNewGetUid)]) {
        [_loginAccountButton setTitle:@"退出账号" forState:UIControlStateNormal];
    }
    
    [YPMediatorPort(YPUserCenterPort) excuteNewGetUid];
    
    [YPProtocolMediator addSelector:@selector(userCenter:loginStatus:) forProtocol:@protocol(YPUserCenterDelegate) block:^(YPParams *params) {
        id target = params[0];
        id target0 = [params objectAtIndex:0];
        NSNumber *status = [params objectAtIndex:1];
        NSLog(@"target %@ , target0 %@, status is %@",target, target0, status);

    } bindTarget:self];
    
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
        
        // 执行登录操作
        [YPMediatorPort(YPUserCenterPort) yp_excuteSelector:@selector(executeLogin:password:) args:@"1851558", @"123456", nil];
    } else {
        [YPMediatorPort(YPUserCenterPort) yp_excuteSelector:@selector(excuteCleanAccount)];
    }
}



- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(float)status {
    if (status) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [_loginAccountButton setTitle:@"请登录账号" forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
}
@end
