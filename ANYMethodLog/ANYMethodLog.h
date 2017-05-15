//
//  ANYMethodLog.h
//  ANYMethodLog
//
//  Created by qiuhaodong on 2017/1/14.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/ANYMethodLog.git
//

#import <Foundation/Foundation.h>

@interface ANYMethodLog : NSObject

/**
 打印对象的方法调用

 @param aClass 目标类
 @param condition 根据此 block 来判断是否追踪方法
 @param before 方法调用前会调用该 block
 @param after 方法调用后会调用该 block
 */
+ (void)logMethodWithClass:(Class)aClass
                 condition:(BOOL(^)(SEL sel))condition
                    before:(void(^)(id target, SEL sel, NSArray *args))before
                     after:(void(^)(id target, SEL sel, NSArray *args, NSTimeInterval interval))after;

@end
