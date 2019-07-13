//
//  YPHomePageInterface.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/5/9.
//  Copyright © 2019 xiaopeng. All rights reserved.
//

#import "YPHomePageInterface.h"
#import "YPHomePageViewController.h"

@interface YPHomePageInterface ()

@end

@implementation YPHomePageInterface

- (UIViewController *)homePageViewController {
    YPHomePageViewController *homePageViewController1 = [[YPHomePageViewController alloc] init];

    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:homePageViewController1];
    return navigation;
}

@end
