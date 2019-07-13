//
//  YPProtocolMediator.m
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import "YPProtocolMediator.h"

@interface YPProtocolModule : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, strong) Protocol *protocol;

@end


@interface YPProtocolMediator ()

@property (nonatomic, strong) NSMutableDictionary *modulesDictionary;
@property (nonatomic, strong) NSMutableDictionary *receiveModulesDictionary;

@property (nonatomic, strong) Protocol *excute_protocol;

@property (nonatomic, strong) NSString *portSuffix;

- (YPProtocolMediator *)set_Excute_protocol:(Protocol *)excute_protocol;

@end

@implementation YPProtocolMediator

+ (instancetype)shareInstance {
    static YPProtocolMediator *mediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[YPProtocolMediator alloc] init];
    });
    return mediator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.portSuffix = @"Port";
        self.modulesDictionary = [NSMutableDictionary dictionary];
        self.receiveModulesDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

/**根据传入的组件协议返回实现该协议的类的对象*/
- (id)moduleInstanceFromProtocol:(Protocol *)protocol {
    NSString *className = NSStringFromProtocol(protocol);
    
    id module = self.modulesDictionary[NSStringFromProtocol(protocol)];
    
    if (module) {
        return module;
    }
    
    
    if ([className hasSuffix:self.portSuffix]) {
        className = [className substringToIndex:className.length - self.portSuffix.length];
    }
    
    Class aClass = NSClassFromString(className);

    if (!aClass) {
        if (self.modulePortPrefix && ![className hasPrefix:self.modulePortPrefix]) {
            className = [NSString stringWithFormat:@"%@%@", self.modulePortPrefix, className];
        }
        
        if (self.modulePortSuffix && ![className hasSuffix:self.modulePortSuffix]) {
            className = [NSString stringWithFormat:@"%@%@", className, self.modulePortSuffix];
        }
        
        aClass = NSClassFromString(className);
    }
    
    if (!aClass && self.defaultModule) {
        aClass = NSClassFromString(self.defaultModule);
    }
    
    module = [[aClass alloc] init];
    
    if ([module conformsToProtocol:protocol]){
        self.modulesDictionary[NSStringFromProtocol(protocol)] = module;
        return module;
    }
    NSLog(@"未找到实现该 %@ 协议的类或组件", NSStringFromProtocol(protocol));
    // 未找到实现该协议的组件
    return nil;
}

- (BOOL)isProtocolInstanceModule:(id)module {
   return [self.modulesDictionary.allValues containsObject:module];
}

- (void)bindModule:(NSObject *)module withDelegateProtocol:(Protocol *)protocol {
//    if (![module conformsToProtocol:protocol]) {
//        NSLog(@"%@ 未实现 %@ 协议", module, NSStringFromProtocol(protocol));
//        return;
//    }

    NSMutableSet *set1 = [self.receiveModulesDictionary objectForKey:NSStringFromProtocol(protocol)];
    
    if (!set1) {
        set1 = [NSMutableSet set];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.target = %@", module];
        NSSet *set = [set1 filteredSetUsingPredicate:predicate];
        if ([set count]) {
            NSLog(@"%@ 已经注册了 protocol: %@", module, NSStringFromProtocol(protocol));
            return;
        }
    }
    YPProtocolModule *receiveModule = [[YPProtocolModule alloc] init];
    receiveModule.target = module;
    receiveModule.protocol = protocol;
    
    [set1 addObject:receiveModule];
    [self.receiveModulesDictionary setObject:set1 forKey:NSStringFromProtocol(protocol)];
}

- (YPProtocolMediator *)set_Excute_protocol:(Protocol *)excute_protocol {
    self.excute_protocol = excute_protocol;
    
    return self;
}

- (NSArray *)delegate_excuteSelector:(SEL)selector {
    return [self delegate_excuteSelector:selector args:nil];
}

- (NSArray *)delegate_excuteSelector:(SEL)selector args:(id)arg, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableSet *set1 = [self.receiveModulesDictionary objectForKey:NSStringFromProtocol(self.excute_protocol)];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
    
    for (YPProtocolModule *protocolModule in set1) {
        if ([protocolModule.target conformsToProtocol:self.excute_protocol] || [protocolModule.target respondsToSelector:selector]) {
            va_list args;
            va_start(args, arg);
            
            id result = [protocolModule.target port_excuteSelector:selector argument:arg argList:args ignoreWarning:YES];
            
            va_end(args);
            
            if (result) {
                [results addObject:result];
            }
        }
    }
    return [results copy];
}

@end


@implementation YPProtocolModule

/*
 addObserver 不能监听 weak 属性 自动置为 nil 的kvo
 */
/*
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"target" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"target"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSObject *oldValue = [change objectForKey:@"old"];
    NSObject *newValue = [change objectForKey:@"new"];
    if (oldValue != newValue && !newValue) {
        NSLog(@"target 销毁了");
    }
    
    NSLog(@"%s\n", __func__);
    NSLog(@"object is %@", object);
}
 */

@end

