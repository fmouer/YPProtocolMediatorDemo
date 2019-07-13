//
//  YPUserCenterProtocol.h
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YPUserCenterPort <NSObject>

//- (NSString *)excuteGetUid __attribute__((deprecated("此方法已弃用,请使用xxxxx:方法"))); // DEPRECATED_MSG_ATTRIBUTE("用 excuteNewGetUid 替换此方法");

- (NSString *)port_Uid;

- (void)port_CleanAccount;
- (void)port_Login:(NSString *)phone password:(NSString *)password;

@end
