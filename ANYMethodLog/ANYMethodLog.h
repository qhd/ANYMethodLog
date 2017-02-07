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

+ (void)logMethodWithClass:(Class)aClass
                 condition:(BOOL(^)(SEL sel))condition
                    before:(void(^)(id target, SEL sel))before
                     after:(void(^)(id target, SEL sel))after;

@end
