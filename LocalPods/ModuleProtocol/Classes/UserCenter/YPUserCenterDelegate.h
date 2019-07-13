//
//  YPUserCenterProtocol.h
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPUserCenterPort.h"

@protocol YPUserCenterDelegate <NSObject>

@optional
- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(BOOL)status;
- (void)userCenter:(id<YPUserCenterPort>)userCenter loginStatus:(BOOL)status array:(NSArray *)dd;

@end
