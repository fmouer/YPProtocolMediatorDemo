//
//  YPBuglyLaunchTask.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/5/24.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "YPBuglyLaunchTask.h"
#import "YPUserCenterDelegate.h"
#import <YPProtocolMediator/YPProtocolMediator.h>

@interface YPBuglyLaunchTask () <YPUserCenterDelegate>

@end

@implementation YPBuglyLaunchTask

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserverForName:YPLaunchTaskInitNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [[self class] add];
    }];
}

- (void)runAppDidFinishLauchingBeforeUI {
    
    [self yp_addDelegateSelector:@selector(userCenter:loginStatus:) paramBlock:^(YPParams *params) {
        NSNumber *loginStatus = [params last];
        NSLog(@"buly 获取到 登录状态： %@", [loginStatus boolValue] ? @"登录成功" : @"退出登录");
        NSLog(@"uid : %@", [YPMediatorPort(YPUserCenterPort) port_excuteSelector:@selector(port_Uid)]);
    } forProtocol:@protocol(YPUserCenterDelegate)];
}


- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(BOOL)status {
    NSLog(@"YPBuglyLaunchTask %d",status);
}

@end
