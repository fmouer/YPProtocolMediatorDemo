//
//  YPLaunchTask.m
//  YouPengTrip
//
//  Created by huangzhimou on 25/2/19.
//  Copyright (c) 2019 huangzhimou. All rights reserved.
//

#import "YPLaunchTask.h"
#import "YPLaunchManager.h"
#import "YPLaunchManager_Protect.h"

@implementation YPLaunchTask

+(void)add {
    [[YPLaunchManager defautlManager] add:[self class]];
}

-(void)finish {
    [[YPLaunchManager defautlManager] removeTask:self];
}

-(NSString *)name {
    return [[self class] description];
}

-(NSUInteger)priority {
    return -1;
}

- (BOOL)finishAfterRun {
    return NO;
}

@end
