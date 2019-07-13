//
//  YPLaunchManager_Protect.h
//  YouPengTrip
//
//  Created by huangzhimou on 25/2/19.
//  Copyright (c) 2019 huangzhimou. All rights reserved.
//

#import "YPLaunchManager.h"

@class YPLaunchTask;

@interface YPLaunchManager ()

-(void)add:(Class)taskClass;

-(void)removeTask:(YPLaunchTask *)task;

@end
