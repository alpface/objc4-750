//
//  Person.h
//  objc-test
//
//  Created by xiaoyuan on 2019/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class School;

@interface Person : NSObject

@property (nonatomic, strong) School *sch;
@property (nonatomic, copy) NSString *name;
extern void run(id self, SEL _cmd);
extern NSNumber *run1(id self, SEL _cmd);

@end

@interface Person (Extesion)

@property NSNumber *num;

@end

NS_ASSUME_NONNULL_END
