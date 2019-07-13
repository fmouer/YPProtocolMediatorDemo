//
//  YPLoginInterface.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/28.
//  Copyright © 2019 xiaopeng. All rights reserved.
//

#import "YPLoginInterface.h"
#import "YPLoginViewController.h"

@interface YPLoginInterface ()

@end
@implementation YPLoginInterface

- (UIViewController *)loginViewController {
    return [[YPLoginViewController alloc] init];
}

@end
