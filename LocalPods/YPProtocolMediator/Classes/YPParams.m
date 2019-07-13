//
//  YPParams.m
//  Pods-YPProtocolMediatorDemo
//
//  Created by huangzhimou on 2019/5/13.
//

#import "YPParams.h"
@interface YPParams ()

@property (nonatomic, copy) NSArray *params;

@end

@implementation YPParams

+ (instancetype)paramsWithArray:(NSArray *)array {
    YPParams *params = [[YPParams alloc] init];
    params.params = array;
    return params;
}

- (id)first {
    return [self objectAtIndex:0];
}

- (id)second {
    return [self objectAtIndex:1];
}

- (id)third {
    return [self objectAtIndex:2];
}

- (id)fourth {
    return [self objectAtIndex:3];
}

- (id)fifth {
    return [self objectAtIndex:4];
}

- (id)last {
    return self.params.lastObject;
}

- (id)objectAtIndex:(NSUInteger)count {
    if (count < self.params.count) {
        id result = [self.params objectAtIndex:count];

        return [result isEqual:[YPNilObject yp_nil]] ? nil : result;

    }
    return nil;
}

@end


@implementation YPNilObject

+ (YPNilObject *)yp_nil {
    static YPNilObject *yp_nil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yp_nil = [[self alloc] init];
    });
    return yp_nil;
}

@end

@implementation YPParams (ObjectSubscripting)

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self objectAtIndex:index];
}

@end
