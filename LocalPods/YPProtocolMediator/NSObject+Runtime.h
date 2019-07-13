//
//  NSObject+Runtime.h
//  XiaoPengQiChe
//
//  Created by PC00138 on 2018/5/30.
//  Copyright © 2018年 xiaopeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Runtime)

#pragma mark - 交换同一个类的不同方法
/**
 交换当前类的两个不同方法

 @param originSEL 源方法
 @param targetSEL 要交换的目标方法
 */
+ (void)swizzleOriginSEL:(SEL)originSEL targetSEL:(SEL)targetSEL;


/**
 交换某个类的两个不同方法

 @param originSEL 源方法
 @param targetSEL 要交换的目标方法
 @param cls 某个类
 */
+ (void)swizzleOriginSEL:(SEL)originSEL targetSEL:(SEL)targetSEL onClass:(Class)cls;

#pragma mark - 交换不同类的方法
/**
 用当前类的源方法和目标类的目标方法交换

 @param originSEL 当前类的源方法
 @param targetCls 目标类
 @param targetSEL 目标方法
 */
+ (void)swizzleOriginSEL:(SEL)originSEL
             targetClass:(NSString *)targetCls
               targetSEL:(SEL)targetSEL;

/**
 用源类的源方法和目标类的目标方法交换

 @param originCls 源类
 @param originSEL 源方法
 @param targetCls 目标类
 @param targetSEL 目标方法
 */
+ (void)swizzleOriginClass:(Class)originCls
                 originSEL:(SEL)originSEL
               targetClass:(Class)targetCls
                 targetSEL:(SEL)targetSEL;

@end
