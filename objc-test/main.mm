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
#import "Person.h"
#import "School.h"

namespace RumTimeDemo {
    class CppClass {
    public:
        Person *_p;
        CppClass(Person *p) {
            _p = p;
        }
        ~CppClass() {
            std::cout << this->_p.description.cString << std::endl;
            this->_p = nil;
        }
    };
}



/*
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
class_addMethod(objc_getClass("Person"), @selector(run), (IMP)runLambda, "V@:");
 */

extern void test02(void);
extern void test_addMethod(void);
extern void test01(void);



void test01() {
    Class newClass = objc_allocateClassPair(objc_getClass("NSObject"), "newClass", 0);
    objc_registerClassPair(newClass);
    id newObject = [[newClass alloc]init];
    NSLog(@"%@",newObject);
}

void test02() {
    NSObject *obj = [[NSObject alloc] init];
    
    //获得NSObject实例对象的成员变量所占用的大小 >> 8
    NSLog(@"%zd", class_getInstanceSize([NSObject class]));
    
    //获得obj指针所指向内存的大小 >> 16
    //malloc_size(const void *ptr):Returns size of given ptr
    NSLog(@"%zd", malloc_size((__bridge const void *)obj));
}

void test_addMethod() {
    Person *person = [Person new];
    School *school = [School new];
    school.per = person;
    person.sch = school;
    person.name = @"xiaoyuan";
    
    // 动态给一个类添加一个方法， 实现未lambda
    void (*runLambda)(id, SEL) = [](id self, SEL _cmd){
        Person *p = self;
        std::cout << p.name.UTF8String << " " << NSStringFromSelector(_cmd).UTF8String << std::endl;
    };
    
    class_addMethod(objc_getClass("Person"), @selector(run), (IMP)runLambda, "V@:");
    
    // 动态给一个类添加一个方法， 实现为objc的方法，带返回值
    class_addMethod(objc_getClass("Person"), @selector(run1), (IMP)run1, "^type@:");
    
    [person performSelector:@selector(run)];
    id ret = [person performSelector:@selector(run1)];
    std::cout << [ret intValue] << std::endl;
    
    
    // 动态给一个类添加一个方法， 实现未block
    void (^runBlock)(id, SEL) = ^(id self, SEL _cmd) {
        Person *p = self;
        std::cout << p.name.UTF8String << " " << NSStringFromSelector(_cmd).UTF8String << std::endl;
    };
    class_addMethod(objc_getClass("Person"), @selector(runBlock), imp_implementationWithBlock(runBlock), "V@:");
    [person performSelector:@selector(runBlock)];
}

void test3() {
    Person *p = [Person new];
    p.name = @"xiaoyuan";
    RumTimeDemo::CppClass *c = new RumTimeDemo::CppClass(p);
    delete c;
}




void test4() {
    Person *p = [Person new];
    p.num = @10;
    p.name = @"xiaoyuan";
    std::cout << p.num.intValue << std::endl;
    RumTimeDemo::CppClass *c = new RumTimeDemo::CppClass(p);
    delete c;
    std::cout << p.description.cString << std::endl;
}




int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        test_addMethod();
//        test3();
        test4();
    }
    return 0;
}


