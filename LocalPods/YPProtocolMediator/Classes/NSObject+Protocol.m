//
//  NSObject+Protocol.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "NSObject+Protocol.h"
#import <objc/runtime.h>
#import "YPProtocolMediator.h"
#import <objc/message.h>
#import "YPParams.h"

/*
// 替换 NSAarray objectAtIndex: 方法，为了假装实现NSArray 能够存储 nil 元素
id yp_c_objectAtIndex(NSArray *self, SEL selector, NSUInteger count) {
//    NSLog(@"yp_c_objectAtIndex self %@", self);
    
    NSMethodSignature* methodSig = [self methodSignatureForSelector:NSSelectorFromString(@"yp_c_objectAtIndex:")];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    invocation.selector = NSSelectorFromString(@"yp_c_objectAtIndex:");
 
    [invocation setArgument:&count atIndex:2];
    
    CFTypeRef typeRef = nil;
    
    [invocation invokeWithTarget:self];
    
    [invocation getReturnValue:&typeRef];
    NSObject *returnResult = CFBridgingRelease(CFBridgingRetain((__bridge id _Nullable)(typeRef)));
//    NSLog(@"class name %@", NSStringFromClass([returnResult class]));
    return [returnResult isEqual:[YPNil yp_nil]] ? nil : returnResult;
}
 
 // NSArray 添加 yp_c_objectAtIndex 方法
 class_addMethod([NSArray class], NSSelectorFromString(@"yp_c_objectAtIndex:"), (IMP)yp_c_objectAtIndex, "@@:i");
 
 // __NSArrayI 是 NSArray 底层真正的类型， objectAtIndex 等系统方法在 __NSArrayI 中
 Method objcAtIndexMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
 Method ypObjcAtIndexMethod = class_getInstanceMethod([NSArray class], NSSelectorFromString(@"yp_c_objectAtIndex:"));
 method_exchangeImplementations(ypObjcAtIndexMethod, objcAtIndexMethod);
 
// objectAtIndexedSubscript: 为 NSArray *array 对象 通过 array[0] 调用时会执行的函数
        Method targetMethod = class_getInstanceMethod(NSClassFromString(@"NSArray"), NSSelectorFromString(@"objectAtIndex:"));
        class_replaceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), @selector(objectAtIndexedSubscript:), (IMP)yp_c_objectAtIndex, "@@:i");

*/

@implementation NSObject (Protocol)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // hook 消息转发 forwardInvocation 流程
        Method method1 = class_getInstanceMethod([self class], @selector(methodSignatureForSelector:));
        Method method2 = class_getInstanceMethod([self class], @selector(yp_methodSignatureForSelector:));

        method_exchangeImplementations(method1, method2);

        Method method4 = class_getInstanceMethod([self class], @selector(yp_forwardInvocation:));
        Method method3 = class_getInstanceMethod([self class], @selector(forwardInvocation:));

        method_exchangeImplementations(method3, method4);
        
    });
}

- (NSMethodSignature *)yp_methodSignatureForSelector:(SEL)aSelector {
    if ([[YPProtocolMediator shareInstance] isProtocolInstanceModule:self]) {
        // 只拦截在 YPProtocolMediator 注册的类，其它的不做处理
        NSMethodSignature *signature = [self yp_methodSignatureForSelector:aSelector];
        if (signature) {
            return signature;
        }
        // 找不到的方法
        return [self yp_methodSignatureForSelector:@selector(doNothing)];
    } else {
        return [self yp_methodSignatureForSelector:aSelector];
    }
}

- (void)yp_forwardInvocation:(NSInvocation *)invocation {
    
    SEL ypTempSelector = [[self class] yp_TempSelector:invocation.selector];
    ParamBlock paramBlock = objc_getAssociatedObject(self, ypTempSelector);
    
    Class class = object_getClass(invocation.target);
    BOOL respondsToSelector = [class instancesRespondToSelector:invocation.selector];
    if (respondsToSelector) {
        [invocation invoke];
    } else if ([class instancesRespondToSelector:ypTempSelector]) {
        invocation.selector = ypTempSelector;
        [invocation invoke];
        respondsToSelector = YES;
    }
    
    if (paramBlock) {
        // 执行注册的block
        paramBlock([YPParams paramsWithArray:[self argumentsInInvocation:invocation]]);
        
        return;
    };
    
    if (respondsToSelector || paramBlock) {
        return;
    }

    // 只做通过 YPProtocolMediator 类调用协议方法时未找到方法实现的 崩溃处理
    if ([[YPProtocolMediator shareInstance] isProtocolInstanceModule:self]) {
        
        NSLog(@"invocation.target %@ can not excute selector '%@'", invocation.target, NSStringFromSelector(invocation.selector));
        
    } else {
        [self yp_forwardInvocation:invocation];
    }
}

- (void)doNothing {
}

- (id)port_excuteSelector:(SEL)selector {
    return [self port_excuteSelector:selector argument:nil argList:nil ignoreWarning:NO];
}

- (id)port_excuteSelector:(SEL)selector args:(id)argument, ... NS_REQUIRES_NIL_TERMINATION {
    // 定义一个指向个数可变的参数列表指针；
    va_list args;
    // 用于存放取出的参数
    
    // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
    va_start(args, argument);
    id result = [self port_excuteSelector:selector argument:argument argList:args ignoreWarning:NO];

    // 清空参数列表，并置参数指针args无效
    va_end(args);
    return result;
}

- (id)port_excuteSelector:(SEL)selector argument:(NSObject *)argument argList:(va_list)argList ignoreWarning:(BOOL)ignoreWarning {
    
    id target = self;
    
    SEL excuteSelector = selector;
    
    SEL ypTempSelector = [[self class] yp_TempSelector:excuteSelector];
    ParamBlock paramBlock = objc_getAssociatedObject(self, ypTempSelector);
    if (paramBlock) {
        /*
         存在添加 tempSelector 方法，则需要把 excuteSelector 指向 ypTempSelector
         因为添加 tempSelector 方法时把他们的函数实现互换了
        */
        excuteSelector = ypTempSelector;
    }

    if (![target respondsToSelector:selector]) {
        // target 不能执行方法
        if (!ignoreWarning) {
            NSLog(@"target %@ can not excute selector '%@'", target, NSStringFromSelector(selector));
        }
        return nil;
    }    
    
    NSMethodSignature* methodSig = [target methodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    invocation.target = target;
    invocation.selector = excuteSelector;
    
    NSInteger numberOfArguments = [methodSig numberOfArguments];
    
    if (numberOfArguments == 2) {
        [self forwardInvocation:invocation];

//        if (paramBlock) {
//            paramBlock(nil);
//        }
//        [invocation invoke];
    } else {
        if (!argument) {
            // 参数不合法
            return nil;
        }
        
        NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
        [arguments addObject:argument];
        
        
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while (1) {
            id argument_ = va_arg(argList, id);
            if (!argument_) {
                break;
            }
            [arguments addObject:argument_];
        }
        
        
        if (numberOfArguments - 2 != arguments.count) {
            // 参数不合法
            return nil;
        }
        
        // 给 invocation 设置参数
        [self setInvocation:invocation arguments:arguments withMethodSignature:methodSig];
        
        [self forwardInvocation:invocation];

//        if (paramBlock) {
//            paramBlock([YPParams paramsWithArray:[arguments copy]]);
//        }
//
//        [invocation invoke];
    }
    
    
    // 返回值
    const char* retType = [methodSig methodReturnType];
    if (strcmp(retType, @encode(void)) == 0) {
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(double)) == 0) {
        double result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    CFTypeRef result = nil;
    [invocation getReturnValue:&result];
    if (result) {
        return CFBridgingRelease(CFRetain(result));
    } else {
        return nil;
    }
}


- (void)yp_addDelegateSelector:(SEL)selector
                    paramBlock:(ParamBlock)paramBlock
                   forProtocol:(Protocol *)protocol {
    // 将 self 与 protocol 绑定
    [[YPProtocolMediator shareInstance] bindModule:self withDelegateProtocol:protocol];
    
    SEL tempSelector = [[self class] yp_TempSelector:selector];
    if (objc_getAssociatedObject(self, tempSelector)) {
        // 已经添加过方法
        return;
    }
    objc_setAssociatedObject(self, tempSelector, paramBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    
    Method targetMethod = class_getInstanceMethod([self class], selector);
    if (targetMethod == NULL) {
        const char *typeEncoding;
        if (protocol == NULL) {
            typeEncoding = YPSignatureForUndefinedSelector(selector);
        } else {
            // Look for the selector as an optional instance method.
            struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
            
            if (methodDescription.name == NULL) {
                // Then fall back to looking for a required instance
                // method.
                methodDescription = protocol_getMethodDescription(protocol, selector, YES, YES);
                NSCAssert(methodDescription.name != NULL, @"Selector %@ does not exist in <%s>", NSStringFromSelector(selector), protocol_getName(protocol));
            }
            
            typeEncoding = methodDescription.types;
        }
        
        YPCheckTypeEncoding(typeEncoding);
        
        // 将 selector 方法的实现 设置成消息转发的流程， 通过 NSInvocation
        if (!class_addMethod([self class], selector, _objc_msgForward, typeEncoding)) {
            // 添加方法失败
        }
    } else if (method_getImplementation(targetMethod) != _objc_msgForward) {
        // 如果 class 存在 selector 方法的实现，则添加一个 tempSelector，为了在消息转发过程中既能执行 class 已实现的 selector，也能执行注册的block
        const char *typeEncoding = method_getTypeEncoding(targetMethod);
        YPCheckTypeEncoding(typeEncoding);
        // tempSelector 实现的 指向 selector 的函数地址
        BOOL addeTempSelectorResult __attribute__((unused)) = class_addMethod([self class], tempSelector, method_getImplementation(targetMethod), typeEncoding);
        // 添加方法失败
        NSCAssert(addeTempSelectorResult, @"Original implementation for %@ is already copied to %@ on %@", NSStringFromSelector(selector), NSStringFromSelector(tempSelector), [self class]);
        
        // 替换 selector 的实现。调用 selector 时走消息转发流程
        class_replaceMethod([self class], selector, _objc_msgForward, method_getTypeEncoding(targetMethod));
    }
}

+ (SEL)yp_TempSelector:(SEL)selector {
    if ([NSStringFromSelector(selector) hasPrefix:@"yp_temp_"]) {
        return selector;
    }
    NSString *tempSelector = [NSString stringWithFormat:@"yp_temp_%@", NSStringFromSelector(selector)];
    return NSSelectorFromString(tempSelector);
}

// selector 没有定义，通过函数名中间的“:” 来添加默认 id 的字符串编码类型
static const char *YPSignatureForUndefinedSelector(SEL selector) {
    const char *name = sel_getName(selector);
    NSMutableString *signature = [NSMutableString stringWithString:@"v@:"];
    
    while ((name = strchr(name, ':')) != NULL) {
        [signature appendString:@"@"];
        name++;
    }
    
    return signature.UTF8String;
}

// 判断是否支持参数的编码类型：不支持 C/C++ 中的数据结构类型
static void YPCheckTypeEncoding(const char *typeEncoding) {
#if !NS_BLOCK_ASSERTIONS
    // Some types, including vector types, are not encoded. In these cases the
    // signature starts with the size of the argument frame.
    NSCAssert(*typeEncoding < '1' || *typeEncoding > '9', @"unknown method return type not supported in type encoding: %s", typeEncoding);
    NSCAssert(strstr(typeEncoding, "(") != typeEncoding, @"union method return type not supported");
    NSCAssert(strstr(typeEncoding, "{") != typeEncoding, @"struct method return type not supported");
    NSCAssert(strstr(typeEncoding, "[") != typeEncoding, @"array method return type not supported");
    NSCAssert(strstr(typeEncoding, @encode(_Complex float)) != typeEncoding, @"complex float method return type not supported");
    NSCAssert(strstr(typeEncoding, @encode(_Complex double)) != typeEncoding, @"complex double method return type not supported");
    NSCAssert(strstr(typeEncoding, @encode(_Complex long double)) != typeEncoding, @"complex long double method return type not supported");
    
#endif // !NS_BLOCK_ASSERTIONS
}

/**
 *
 * 从 NSInvocation 中获取执行的参数
 **/
- (NSArray *)argumentsInInvocation:(NSInvocation *)invocation {
    NSInteger numberOfArguments = [invocation.methodSignature numberOfArguments];
    
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:numberOfArguments - 2];
    // 取出参数列表
    for (NSInteger index = 2; index < numberOfArguments; index ++) {
        const char * type = [invocation.methodSignature getArgumentTypeAtIndex:index];
        
        if (strcmp(type, @encode(NSInteger)) == 0) {
            NSInteger argument = 0;
            [invocation getArgument:&argument atIndex:index];
            [params addObject:@(argument)];
        } else if (strcmp(type, @encode(double)) == 0) {
            double argument = 0.0;
            [invocation getArgument:&argument atIndex:index];
            [params addObject:@(argument)];
        } else if (strcmp(type, @encode(int)) == 0) {
            int argument = 0;
            [invocation getArgument:&argument atIndex:index];
            [params addObject:@(argument)];
        } else if (strcmp(type, @encode(float)) == 0) {
            float argument = 0.0;
            [invocation getArgument:&argument atIndex:index];
            [params addObject:@(argument)];
        } else if (strcmp(type, @encode(NSUInteger)) == 0) {
            NSUInteger argument = 0;
            [invocation getArgument:&argument atIndex:index];
            [params addObject:@(argument)];
        } else if (strcmp(type, @encode(BOOL)) == 0) {
            BOOL argument = NO;
            [invocation getArgument:&argument atIndex:index];
            [params addObject:@(argument)];
        } else {
            CFTypeRef argument = nil;
            [invocation getArgument:&argument atIndex:index];
            
            if (argument) {
                [params addObject:CFBridgingRelease(CFRetain(argument))];
            } else {
                [params addObject:YPNilObject.yp_nil];
            }
        }
    }
    return [params copy];
}

/**
 * 给 invocation 设置参数
 * methodSig 为 selector 的签名
 **/
- (void)setInvocation:(NSInvocation *)invocation
            arguments:(NSArray *)arguments
  withMethodSignature:(NSMethodSignature *)methodSig {
    
    for (NSInteger i = 0; i < arguments.count; i ++) {
        id argument = [arguments objectAtIndex:i];
        const char *type = [methodSig getArgumentTypeAtIndex:i + 2];
        // 判断参数类型
        if (strcmp(type, @encode(NSInteger)) == 0) {
            NSInteger argumenti = [argument integerValue];
            [invocation setArgument:&argumenti atIndex:i + 2];
        } else if (strcmp(type, @encode(double)) == 0) {
            double argumentD = [argument doubleValue];
            [invocation setArgument:&argumentD atIndex:i + 2];
        } else if (strcmp(type, @encode(int)) == 0) {
            int argumenti = [argument intValue];
            [invocation setArgument:&argumenti atIndex:i + 2];
        } else if (strcmp(type, @encode(float)) == 0) {
            float argumenti = [argument floatValue];
            [invocation setArgument:&argumenti atIndex:i + 2];
        } else if (strcmp(type, @encode(NSUInteger)) == 0) {
            NSUInteger argumenti = [argument unsignedIntegerValue];
            [invocation setArgument:&argumenti atIndex:i + 2];
        } else if (strcmp(type, @encode(BOOL)) == 0) {
            BOOL argumenti = [argument boolValue];
            [invocation setArgument:&argumenti atIndex:i + 2];
        } else {
            if (argument == YPNilObject.yp_nil || [argument isKindOfClass:[NSNull class]]) {
                id obj = nil;
                [invocation setArgument:&obj atIndex:i + 2];
            } else {
                [invocation setArgument:&argument atIndex:i + 2];
            }
        }
    }
}

@end
