//
//  ViewController.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 xiaopeng. All rights reserved.
//

#import "ViewController.h"
#import "YPProtocolMediator.h"
#import "YPUserCenterPort.h"
#import "YPUserCenterDelegate.h"
#import "NSObject+Protocol.h"

@interface ViewController ()<YPUserCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
//    [[YPProtocolMediator shareInstance] moduleInstanceFromProtocol:@protocol(YPUserCenterProtocol)];
    
    YPMediatorBind(self, YPUserCenterPort);

    [YPMediatorPort(YPUserCenterPort) yp_excuteSelector:@selector(executeLogin:) args:@"1851558", nil];
    
//    [YPMediatorPort(YPUserCenterPort) excuteNewGetUid];
    
    NSString *newUid = [YPMediatorPort(YPUserCenterPort) yp_excuteSelector:@selector(excuteNewGetUid)];
    NSLog(@"newUid = %@", newUid);

    NSString *uid = [YPMediatorPort(YPUserCenterPort) yp_excuteSelector:@selector(excuteGetUid)];

    NSLog(@"uid = %@", uid);
    
    [[self rac_signalForSelector:@selector(userCenter:loginStatus:)] subscribeNext:^(RACTuple * _Nullable x) {
        ;
    }];
*/
}

//- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(BOOL)status {
//    NSLog(@"status is %d", status);
//}

- (NSString *)userCenterProtocolRecevieLoginData {
    return @"pwd";
}

@end
