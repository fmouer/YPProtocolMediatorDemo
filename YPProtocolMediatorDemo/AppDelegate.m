//
//  YPAppDelegate.m
//  YouPengTrip
//
//  Created by huangzhimou on 2019/4/12.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "AppDelegate.h"
#import "YPLaunchManager.h"
#import "YPHomePagePort.h"
#import "YPProtocolMediator.h"
#import "NSObject+Protocol.h"
#import <objc/runtime.h>


@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[YPLaunchManager defautlManager] loadAllLaunchTask];
    
    [[YPLaunchManager defautlManager] runAppDidFinishLauchingBeforeUI];
    
    /* 设置组件的后缀
       YPProtocolMediator 是通过protocol名字 和 组件实现类的名字进行匹配查找的
       支持 实现类带有后缀
       比如：设置 modulePortSuffix = @“Interface”
       YPProtocolMediator 查找时 YPHomePagePort 组件实现时，会先去掉尾部的 Port，并且拼接Interface进行查找
       即会查找到 YPHomePageInterface 这个类
     
       同理：modulePortPrefix 前缀设置也是同样原理
     */
    [YPProtocolMediator shareInstance].modulePortSuffix = @"Interface";
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [YPMediatorPort(YPHomePagePort) port_excuteSelector:@selector(port_homePageViewController)];
    
    [self.window makeKeyAndVisible];
    
    [[YPLaunchManager defautlManager] runAppDidFinishLauchingAfterUI];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[YPLaunchManager defautlManager] runAppDidEnterBackground];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[YPLaunchManager defautlManager] runAppWillEnterForeground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[YPLaunchManager defautlManager] runAppWillTerminate];
}

@end
