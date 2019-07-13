//
//  YPParams.h
//  Pods-YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/5/13.
//

#import <Foundation/Foundation.h>

#define YPParamVaule(Param) ((Param == nil) ? YPNilObject.yp_nil : Param)


@interface YPParams : NSObject

+ (id)paramsWithArray:(NSArray *)array;

- (id)first;
- (id)second;
- (id)third;
- (id)fourth;
- (id)fifth;
- (id)last;

- (id)objectAtIndex:(NSUInteger)count;

@end

@interface YPNilObject : NSObject
+ (YPNilObject *)yp_nil;
@end


// 暴露 objectAtIndexedSubscript: 方法后，实例变量可以通过 param[0] 获取参数
@interface YPParams (ObjectSubscripting)

- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end

