//
//  YPUserCenterProtocol.h
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;

@protocol YPLoginPort <NSObject>

- (UIViewController *)port_loginViewController;

@end
