//
//  main.m
//  objc_ios
//
//  Created by xiaoyuan on 2019/1/14.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        Class newClass = objc_allocateClassPair(objc_getClass("NSObject"), "newClass", 0);
        objc_registerClassPair(newClass);
        id newObject = [[newClass alloc]init];
        NSLog(@"%@",newObject);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
