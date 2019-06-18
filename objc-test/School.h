//
//  School.h
//  objc-test
//
//  Created by xiaoyuan on 2019/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Person;

@interface School : NSObject

@property (nonatomic, weak) Person *per;

@end

NS_ASSUME_NONNULL_END
