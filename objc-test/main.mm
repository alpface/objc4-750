//
//  main.m
//  objc-test
//
//  Created by GongCF on 2018/12/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <malloc/malloc.h>
#include <iostream>

using namespace std;

@class Person;

@interface School : NSObject

@property (nonatomic, weak) Person *per;

@end

@interface Person : NSObject

@property (nonatomic, strong) School *sch;
@property (nonatomic, copy) NSString *name;
extern void run(id self, SEL _cmd);
extern NSNumber *run1(id self, SEL _cmd);
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Class newClass = objc_allocateClassPair(objc_getClass("NSObject"), "newClass", 0);
                objc_registerClassPair(newClass);
        id newObject = [[newClass alloc]init];
        NSLog(@"%@",newObject);
        
        NSObject *obj = [[NSObject alloc] init];
        
        //获得NSObject实例对象的成员变量所占用的大小 >> 8
        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
        
        //获得obj指针所指向内存的大小 >> 16
        //malloc_size(const void *ptr):Returns size of given ptr
        NSLog(@"%zd", malloc_size((__bridge const void *)obj));
        
        Person *person = [Person new];
        School *school = [School new];
        school.per = person;
        person.sch = school;
        person.name = @"xiaoyuan";
        
        void (*runLambda)(id, SEL) = [](id self, SEL _cmd){
            Person *p = self;
            cout << p.name.UTF8String << " " << NSStringFromSelector(_cmd).UTF8String << endl;
        };
        
        /**
         cls：被添加方法的类
         name：可以理解为方法名，这个貌似随便起名，比如我们这里叫run
         imp：实现这个方法的函数地址
         types：一个定义该函数返回值类型和参数类型的字符串
         types参数为"i@:@“，按顺序分别表示：
         i：返回值类型int，若是v则表示void
         @：参数id(self)
         :：SEL(_cmd)
         @：id(str)
         ^type: 指针类型
         这些表示方法都是定义好的(Type Encodings)，关于Type Encodings的其他类型定义请参考官方文档https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         */
        class_addMethod(objc_getClass("Person"), @selector(run), (IMP)runLambda, "V@:");
        class_addMethod(objc_getClass("Person"), @selector(run1), (IMP)run1, "^type@:");
        
        [person performSelector:@selector(run)];
        id ret = [person performSelector:@selector(run1)];
        cout << [ret intValue] << endl;
    }
    return 0;
}


@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
void run(id self, SEL _cmd) {
    cout << self << _cmd << endl;
}
NSNumber *run1(id self, SEL _cmd) {
    return @10;
}
@end

@implementation School

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
