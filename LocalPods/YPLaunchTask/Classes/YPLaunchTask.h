//
//  YPLaunchTask.h
//  YouPengTrip
//
//  Created by huangzhimou on 25/2/19.
//  Copyright (c) 2019 huangzhimou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YPLaunchTaskDelegate <NSObject>

@optional
- (void)runAppDidFinishLauchingBeforeUI;
- (void)runAppDidFinishLauchingAfterUI;

- (void)runAppWillEnterForeground;
- (void)runAppDidEnterBackground;
- (void)runAppWillTerminate;
- (void)runIrdetoSuccessAfter;
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options ;
- (void)runAppDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)runAppDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

@end

static NSString * const YPLaunchTaskInitNotification = @"YPLaunchTaskInitNotification";

/**
 priority
    0~100 basic
    101~200 important
 */
@interface YPLaunchTask : NSObject <YPLaunchTaskDelegate>

+ (void)add;

- (void)finish;

- (NSUInteger)priority;
- (NSString*)name;

- (BOOL)finishAfterRun; //default NO

@end
