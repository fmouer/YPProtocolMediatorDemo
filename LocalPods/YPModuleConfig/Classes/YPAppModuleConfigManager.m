//
//  YPAppModuleConfigManager.m
//  YouPengTrip
//
//  Created by huangzhimou on 2019/3/21.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "YPAppModuleConfigManager.h"
#import "NSObject+YYModel.h"

@interface YPAppModuleConfigManager ()

@property (nonatomic, copy) NSDictionary *modulesData;

@property (nonatomic, strong) NSMutableDictionary *configModels;
@property (nonatomic, strong) dispatch_queue_t processQueue;

@end

@implementation YPAppModuleConfigManager

+ (instancetype)sharedManager {
    static YPAppModuleConfigManager *sharedInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[YPAppModuleConfigManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _configModels = @{}.mutableCopy;
        _processQueue = dispatch_queue_create("YPAppModuleConfigManager", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (id)parseModuleConfigClass:(Class)clz {
    return [self parseModuleConfigClass:clz withKey:NSStringFromClass(clz)];
}

// 通过key和class解析出对应的moduleConfig
- (id)parseModuleConfigClass:(Class)clz withKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    
    id configModel = [[YPAppModuleConfigManager sharedManager] moduleConfigForKey:key];
    
    if (configModel) {
        return configModel;
    }
    
    NSDictionary *data = [YPAppModuleConfigManager sharedManager].modulesData[key];
    configModel = [clz yy_modelWithJSON:data];
    if (configModel) {
        [[YPAppModuleConfigManager sharedManager] setModuleConfig:configModel forKey:key];
    } else {
        NSLog(@"parse error : key=%@ , data=%@", key, data);
    }
    return configModel;
}

// 加载json文件
- (void)loadModuleConfigWithPath:(NSString *)configPath {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:configPath] options:0 error:&error];
    if (!error && dict) {
        if (self.modulesData) {
            NSMutableDictionary *tempModulesData = [self.modulesData mutableCopy];
            [tempModulesData addEntriesFromDictionary:dict];
            self.modulesData = tempModulesData;
        } else {
            self.modulesData = dict;
        }
    } else {
        NSAssert(NO, @"配置路径或文件格式有误，path: %@", configPath);
    }
}

- (void)setModuleConfig:(id)configModel forKey:(NSString *)key {
    if (key.length) {
        dispatch_async(self.processQueue, ^{
            self.configModels[key] = configModel;
        });
    }
}

- (id)moduleConfigForKey:(NSString *)key {
    if (key.length) {
        __block id obj;
        dispatch_sync(self.processQueue, ^{
            obj = self.configModels[key];
        });
        return obj;
    }
    return nil;
}

@end
