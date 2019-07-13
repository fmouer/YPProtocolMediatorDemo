//
//  YPProtocolMediator.h
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Protocol.h"

#define YPMediatorPort(ModulePortProtocol) [[YPProtocolMediator shareInstance] moduleInstanceFromProtocol:@protocol(ModulePortProtocol)]

#define YPMediatorBind(Module ,ModuleDelegateProtocol) [[YPProtocolMediator shareInstance] bindModule:Module withDelegateProtocol:@protocol(ModuleDelegateProtocol)]

#define YPMediatorDelegate(ModuleDelegateProtocol) [[YPProtocolMediator shareInstance] set_Excute_protocol:@protocol(ModuleDelegateProtocol)]

@interface YPProtocolMediator : NSObject

@property (nonatomic, strong) NSString *modulePortPrefix;
@property (nonatomic, strong) NSString *modulePortSuffix;

@property (nonatomic, strong) NSString *defaultModule;

+ (instancetype)shareInstance;

/**
 * brief 配合 YPMediatorDelegate(XXXPort) 使用的方法
 * brief 组件通过此方法进行代理通信
 *
 **/
- (NSArray *)delegate_excuteSelector:(SEL)selector;

/**
 * brief 配合 YPMediatorDelegate(XXXPort) 使用的方法
 * brief 组件通过此方法进行代理通信
 *
 * @param arg 注意args 不要传 nil ，因为可变参数遇到nil会认为是个参数结束标志,
          如果不能确定所传入的参数是否有值，参数请用 YPParamVaule(Param) 这个宏来传入
 **/
- (NSArray *)delegate_excuteSelector:(SEL)selector args:(id)arg, ... NS_REQUIRES_NIL_TERMINATION;



- (void)bindModule:(NSObject *)module withDelegateProtocol:(Protocol *)protocol;

- (YPProtocolMediator *)set_Excute_protocol:(Protocol *)excute_protocol;

- (id)moduleInstanceFromProtocol:(Protocol *)protocol;

- (BOOL)isProtocolInstanceModule:(id)module;

@end

