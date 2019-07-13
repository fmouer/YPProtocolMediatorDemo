//
//  YPLaunchManager.m
//  YouPengTrip
//
//  Created by huangzhimou on 25/2/19.
//  Copyright (c) 2019 huangzhimou. All rights reserved.
//

#import "YPLaunchManager.h"
#import "YPLaunchManager_Protect.h"
#import "YPLaunchTask.h"
#import "DPLog.h"

static YPLaunchManager *_instance = nil;

@interface YPLaunchManager ()
@property (nonatomic,strong) NSMutableArray *tasks;
@property (nonatomic,strong) NSMutableArray *taskClasses;
@end

@implementation YPLaunchManager

+ (instancetype)defautlManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YPLaunchManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tasks = [NSMutableArray array];
        self.taskClasses = [NSMutableArray array];
    }
    return self;
}

- (void)loadAllLaunchTask {
    [[NSNotificationCenter defaultCenter] postNotificationName:YPLaunchTaskInitNotification object:nil];
    [self instantiateTask];
}

-(void)add:(Class)taskClass {
    NSLog(@"add class %@", NSStringFromClass(taskClass));
    [self.taskClasses addObject:taskClass];
}

-(void)addTask:(YPLaunchTask *)task{
    [self.tasks addObject:task];
}

-(void)removeTask:(YPLaunchTask *)task{
    [self.tasks removeObject:task];
}

-(void)instantiateTask {
    NSArray *tc = [NSArray arrayWithArray:self.taskClasses];
    for (Class cl in tc) {
        [self addTask:[[cl alloc] init]];
    }
}

-(void)runAction:(SEL)action param:(id)param {
  
    NSArray *runTask = [self runTaskResondsSelector:action];
    
    NSMutableArray *removeAfterRun = [NSMutableArray arrayWithCapacity:self.tasks.count];
    for (YPLaunchTask *task in runTask) {
        
        NSLog(@"run task(%@) %@, Selector: %@",@([task priority]),[task name], NSStringFromSelector(action));
        
#pragma GCC diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [task performSelector:action withObject:param];
#pragma GCC diagnostic pop
        
        if (task.finishAfterRun) {
            [removeAfterRun addObject:task];
        }
    }
    
    // 移除执行后需要删掉的task，以后做优化。
    // 如果task有两个方法执行后才需要删掉情况，暂时无法满足
    for (id task in removeAfterRun) {
        [self.tasks removeObject:task];
    }
}

- (void)runAppDidFinishLauchingBeforeUI {
    [self runAction:@selector(runAppDidFinishLauchingBeforeUI) param:nil];
}

- (void)runAppDidFinishLauchingAfterUI {
    [self runAction:@selector(runAppDidFinishLauchingAfterUI) param:nil];
}

- (void)runAppWillEnterForeground {
    [self runAction:@selector(runAppWillEnterForeground) param:nil];
}
- (void)runAppDidEnterBackground {
    [self runAction:@selector(runAppDidEnterBackground) param:nil];
}

- (void)runAppWillTerminate {
    [self runAction:@selector(runAppWillTerminate) param:nil];
}

- (void)runIrdetoSuccessAfter {
    [self runAction:@selector(runIrdetoSuccessAfter) param:nil];
}

- (void)runAppDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self runAction:@selector(runAppDidRegisterForRemoteNotificationsWithDeviceToken:) param:deviceToken];
}

- (void)runAppDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self runAction:@selector(runAppDidFailToRegisterForRemoteNotificationsWithError:) param:error];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options   {
    for (YPLaunchTask *task in self.tasks) {
        if ([task respondsToSelector:@selector(application:openURL:options:)]) {
            BOOL responds = [task application:app openURL:url options:options];
            // 有模块能够执行 URL
            if (responds) {
                return responds;
            }
        }
    }
    
    return NO;
}

- (NSArray *)runTaskResondsSelector:(SEL)selector {
    NSMutableArray *runTask = [NSMutableArray arrayWithCapacity:self.tasks.count];
    for (YPLaunchTask *task in self.tasks) {
        // 找到能执行action的task
        if ([task respondsToSelector:selector]) {
            [runTask addObject:task];
        }
    }
    
    [runTask sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result;
        YPLaunchTask *task1 = obj1;
        YPLaunchTask *task2 = obj2;
        NSUInteger pri1 = [task1 priority];
        NSUInteger pri2 = [task2 priority];
        if (pri1 == pri2) {
            result = NSOrderedSame;
        }else if (pri1 < pri2){
            result = NSOrderedAscending;
        }else{
            result = NSOrderedDescending;
        }
        return result;
    }];
    return [runTask copy];
}

@end
