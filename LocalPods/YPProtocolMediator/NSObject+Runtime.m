//
//  NSObject+Runtime.m
//  XiaoPengQiChe
//
//  Created by PC00138 on 2018/5/30.
//  Copyright © 2018年 xiaopeng.com. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject(Runtime)

#pragma mark - 交换同一个类的不同方法

+ (void)swizzleOriginSEL:(SEL)originSEL targetSEL:(SEL)targetSEL {
    Class cls = [self class];
    [self swizzleOriginSEL:originSEL targetSEL:targetSEL onClass:cls];
}


+ (void)swizzleOriginSEL:(SEL)originSEL targetSEL:(SEL)targetSEL onClass:(Class)cls {
    Method originMethod = class_getInstanceMethod(cls, originSEL);
    Method targetMethod = class_getInstanceMethod(cls, targetSEL);
    
    BOOL didAddMethod =
    class_addMethod(cls,
                    originSEL,
                    method_getImplementation(targetMethod),
                    method_getTypeEncoding(targetMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            targetSEL,
                            method_getImplementation(originMethod),
                            method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, targetMethod);
    }
}

#pragma mark - 交换不同类的方法

+ (void)swizzleOriginSEL:(SEL)originSEL
             targetClass:(NSString *)targetCls
               targetSEL:(SEL)targetSEL {
    if (!targetCls || 0 == [targetCls length]) {
        return;
    }
    Class originCls = [self class];
    Class targetClass = NSClassFromString(targetCls);
    [self swizzleOriginClass:originCls
                   originSEL:originSEL
                 targetClass:targetClass
                   targetSEL:targetSEL];
}


+ (void)swizzleOriginClass:(Class)originCls
                 originSEL:(SEL)originSEL
               targetClass:(Class)targetCls
                 targetSEL:(SEL)targetSEL {
    if (!originCls) {
        return;
    }
    if (!originSEL) {
        return;
    }
    if (!targetCls) {
        return;
    }
    if (!targetSEL) {
        return;
    }
    Method originMethod = class_getInstanceMethod(originCls,originSEL);
    Method targetMethod = class_getInstanceMethod(targetCls,targetSEL);
    method_exchangeImplementations(originMethod, targetMethod);
}

@end
