//
//  YPUserCenter.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "YPUserCenter.h"
#import "YPProtocolMediator.h"
#import "NSObject+Protocol.h"

@interface YPUserCenter ()

@property (nonatomic, copy) NSString *uid;

@end

@implementation YPUserCenter

- (NSString *)port_Uid {
    return self.uid;
}

- (void)port_Login:(NSString *)phone password:(NSString *)password {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /*
        NSArray *pwd = [YPMediator(YPUserCenterProtocol) excuteSelector:@selector(userCenterProtocolRecevieLoginData) arg: nil];
        
        NSLog(@"recevie pwd = %@", pwd.firstObject);
        */
        
        self.uid = @"Uid123456";
        
        // 登录成功
        [YPMediatorDelegate(YPUserCenterDelegate) delegate_excuteSelector:@selector(userCenter:loginStatus:) args:self, @(YES), nil];
        
    });
}


- (void)port_CleanAccount {
    self.uid = nil;
    
    [YPMediatorDelegate(YPUserCenterDelegate) delegate_excuteSelector:@selector(userCenter:loginStatus:) args:self, @(NO), nil];

}


@end
