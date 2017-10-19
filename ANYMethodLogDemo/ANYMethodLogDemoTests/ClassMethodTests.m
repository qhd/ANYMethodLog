//
//  ClassMethodTests.m
//  ANYMethodLogDemo
//
//  Created by qiuhaodong on 2017/1/23.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ANYMethodLog.h"

@interface ManagerTest : NSObject

+ (NSString *)classMethod1:(NSString *)a;

- (NSString *)instanceMethod1:(NSString *)a;

@end

@implementation ManagerTest

+ (NSString *)classMethod1:(NSString *)a {
    return a;
}

- (NSString *)instanceMethod1:(NSString *)a {
    return a;
}

@end

@interface ClassMethodTests : XCTestCase

@end

@implementation ClassMethodTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testManagerTest {
    [ANYMethodLog logMethodWithClass:[ManagerTest class] condition:^BOOL(SEL sel) {
        return YES;
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        NSLog(@"befor target:%@ sel:%@", target, NSStringFromSelector(sel));
    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
        NSLog(@"after target:%@ sel:%@", target, NSStringFromSelector(sel));
    }];
    
    XCTAssertTrue([@"qhd" isEqualToString:[ManagerTest classMethod1:@"qhd"]]);
    
    XCTAssertTrue([@"github" isEqualToString:[[[ManagerTest alloc] init] instanceMethod1:@"github"]]);
}

@end
