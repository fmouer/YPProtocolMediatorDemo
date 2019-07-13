//
//  YPAppModuleConfigManager.h
//  YouPengTrip
//
//  Created by huangzhimou on 2019/3/21.
//  Copyright © 2019 fmouer All rights reserved.
//

#import <Foundation/Foundation.h>

#define YPConfigManager [YPAppModuleConfigManager sharedManager]

NS_ASSUME_NONNULL_BEGIN

@interface YPAppModuleConfigManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, copy, readonly) NSDictionary *modulesData;

- (void)loadModuleConfigWithPath:(NSString *)configPath;

- (id)parseModuleConfigClass:(Class)clz;

- (id)parseModuleConfigClass:(Class)clz withKey:(NSString *)key;
- (void)setModuleConfig:(id)configModel forKey:(NSString *)key;
- (id)moduleConfigForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
