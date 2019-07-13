//
//  YPCommonProtocol.h
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/28.
//  Copyright © 2019 xiaopeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol YPCommonProtocol <NSObject>

+ (NSString *)commonBusinessId;

- (nullable UIViewController *)openBusinessPath:(nonnull NSURL *)URL params:(nullable NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
