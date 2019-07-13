//
//  YPCommonLaunchTask.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/7/13.
//  Copyright © 2019 xiaopeng. All rights reserved.
//

#import "YPCommonLaunchTask.h"
#import "YPAppModuleConfigManager.h"
#import <YPProtocolMediator/YPProtocolMediator.h>

@implementation YPCommonLaunchTask


+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLaunchTask) name:YPLaunchTaskInitNotification object:nil];
}

+ (void)loadLaunchTask {
    [[self class] add];
}

// YPCommonLaunchTask 优先级
- (NSUInteger)priority {
    return 0;
}

- (BOOL)finishAfterRun {
    return YES;
}

- (void)runAppDidFinishLauchingBeforeUI {
    
    [YPProtocolMediator shareInstance].modulePortSuffix = @"Interface";
    [YPProtocolMediator shareInstance].modulePortPrefix = @"YP";
    
    // 加载 Module 的config
    NSString *ModuleConfigPath = [[NSBundle mainBundle] pathForResource:@"ModuleConfig" ofType:@"json"];
    [YPConfigManager loadModuleConfigWithPath:ModuleConfigPath];
    
}

@end
