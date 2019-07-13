//
//  NSObject+Protocol.h
//  YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/4/27.
//  Copyright © 2019 fmouer All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPParams.h"

typedef void(^ParamBlock)(YPParams *params);

@interface NSObject (Protocol)

/**
 * brief 配合 YPMediatorPort(XXXPort) 使用的方法
 *
 * @param selector 为 protocol 暴露的方法
 * @return Selector 返回值
 **/
- (id)port_excuteSelector:(SEL)selector;

/**
 * brief 配合 YPMediatorPort(XXXPort) 使用的方法
 *
 * @param selector 为 protocol 暴露的方法，
 * @param arg ... 为 Selector 参数 list,
          注意：如果某个参数为nil，需要用 YPNil.yp_nil 代替，因为 nil 是参数列表结束的标志
 * @return Selector 返回值
 **/
- (id)port_excuteSelector:(SEL)selector args:(id)arg, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @param selector 给 类对象 添加 Selector
 * @param protocol 为 Selector 所在的协议方法声明中
 * @param paramBlock 调用 Selector 时触发的block，YPParams 为 Selector 的参数集
 **/
- (void)yp_addDelegateSelector:(SEL)selector
                    paramBlock:(ParamBlock)paramBlock
                   forProtocol:(Protocol *)protocol;


- (id)port_excuteSelector:(SEL)selector argument:(NSObject *)argument argList:(va_list)argList ignoreWarning:(BOOL)ignoreWarning;

@end

