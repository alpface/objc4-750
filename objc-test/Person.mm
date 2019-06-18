//
//  Person.m
//  objc-test
//
//  Created by xiaoyuan on 2019/6/18.
//

#import "Person.h"
#include <iostream>
#import <objc/runtime.h>

@implementation Person

+ (void)load {
    NSLog(@"%s", __func__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
void run(id self, SEL _cmd) {
    std::cout << self << _cmd << std::endl;
}
NSNumber *run1(id self, SEL _cmd) {
    return @10;
}
@end

@implementation Person (Extesion)
+ (void)load {
    NSLog(@"%s", __func__);
}
- (void)setNum:(NSNumber *)num {
    objc_setAssociatedObject(self, @selector(num), num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)num {
    return objc_getAssociatedObject(self, @selector(num));
}

@end
