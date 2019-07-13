//
//  YPUserCenterProtocol.h
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 xiaopeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YPMQTTProtocol <NSObject>

@optional

- (void)connect;

- (void)disConnect;

@end

NS_ASSUME_NONNULL_END
