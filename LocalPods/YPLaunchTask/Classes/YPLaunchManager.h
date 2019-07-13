//
//  YPLaunchManager.h
//  YouPengTrip
//
//  Created by huangzhimou on 25/2/19.
//  Copyright (c) 2019 huangzhimou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPLaunchManager : NSObject

+ (instancetype)defautlManager;

- (void)loadAllLaunchTask;

- (void)runAppDidFinishLauchingBeforeUI;
- (void)runAppDidFinishLauchingAfterUI;

- (void)runAppWillEnterForeground;
- (void)runAppDidEnterBackground;
- (void)runAppWillTerminate;

- (void)runIrdetoSuccessAfter;

- (void)runAppDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)runAppDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end
