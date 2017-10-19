//
//  ANYMethodLogDemoTests.m
//  ANYMethodLogDemoTests
//
//  Created by qiuhaodong on 2017/1/18.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ANYMethodLog.h"

#pragma mark - 测试类MyObject

@interface MyObject : NSObject

- (BOOL)methodWithA:(char)a
                  b:(int)b
                  c:(short)c
                  d:(long)d
                  e:(long long)e
                  f:(unsigned char)f
                  g:(unsigned int)g
                  h:(unsigned short)h
                  i:(unsigned long)i
                  j:(unsigned long long)j
                  k:(float)k
                  l:(double)l
                  m:(bool)m
                //n:(void)n
                  o:(char *)o
                  p:(id)p
                  q:(Class)q
                  r:(SEL)r
                  s:(CGRect)s
                  t:(CGPoint)t
                  u:(CGSize)u
                  v:(CGVector)v
                  w:(CGAffineTransform)w
                  x:(UIOffset)x
                  y:(UIEdgeInsets)y;
- (char)method1:(char)a;
- (int)method2:(int)a;
- (short)method3:(short)a;
- (long)method4:(long)a;
- (long long)method5:(long long)a;
- (unsigned char)method6:(unsigned char)a;
- (unsigned int)method7:(unsigned int)a;
- (unsigned short)method8:(unsigned short)a;
- (unsigned long)method9:(unsigned long)a;
- (unsigned long long)method10:(unsigned long long)a;
- (float)method11:(float)a ;
- (double)method12:(double)a;
- (BOOL)method13:(BOOL)a;
- (void)method14;
- (char *)method15:(char *)a;
- (id)method16:(id)a;
- (Class)method17:(Class)a;
- (SEL)method18:(SEL)a;
- (CGRect)method19:(CGRect)a;
- (CGPoint)method20:(CGPoint)a;
- (CGSize)method21:(CGSize)a;
- (CGVector)method22:(CGVector)a;
- (CGAffineTransform)method23:(CGAffineTransform)a;
- (UIEdgeInsets)method24:(UIEdgeInsets)a;
- (UIOffset)method25:(UIOffset)a;
- (NSString *)method26:(NSString *)a;

@end

#define DEFAULT_LOG NSLog(@"cmd:%@", NSStringFromSelector(_cmd))

@implementation MyObject

- (BOOL)methodWithA:(char)a
                  b:(int)b
                  c:(short)c
                  d:(long)d
                  e:(long long)e
                  f:(unsigned char)f
                  g:(unsigned int)g
                  h:(unsigned short)h
                  i:(unsigned long)i
                  j:(unsigned long long)j
                  k:(float)k
                  l:(double)l
                  m:(bool)m
                //n:(void)n
                  o:(char *)o
                  p:(id)p
                  q:(Class)q
                  r:(SEL)r
                  s:(CGRect)s
                  t:(CGPoint)t
                  u:(CGSize)u
                  v:(CGVector)v
                  w:(CGAffineTransform)w
                  x:(UIOffset)x
                  y:(UIEdgeInsets)y
{
    DEFAULT_LOG;
    NSLog(@"a:%@, b:%@, c:%@, d:%@, e:%@, f:%@, g:%@, h:%@, i:%@, j:%@, k:%@, l:%@, m:%@, n:void, o:%@, p:%@, q:%@, r:%@, s:%@, t:%@, u:%@, v:%@, w:%@, x:%@, y:%@",
          [@(a) stringValue],
          [@(b) stringValue],
          [@(c) stringValue],
          [@(d) stringValue],
          [@(e) stringValue],
          [@(f) stringValue],
          [@(g) stringValue],
          [@(h) stringValue],
          [@(i) stringValue],
          [@(j) stringValue],
          [@(k) stringValue],
          [@(l) stringValue],
          [@(m) stringValue],
          [NSString stringWithUTF8String:o],
          p,
          NSStringFromClass(q),
          NSStringFromSelector(r),
          NSStringFromCGRect(s),
          NSStringFromCGPoint(t),
          NSStringFromCGSize(u),
          NSStringFromCGVector(v),
          NSStringFromCGAffineTransform(w),
          NSStringFromUIOffset(x),
          NSStringFromUIEdgeInsets(y)
          );
    return YES;
}

- (char)method1:(char)a {
    DEFAULT_LOG;
    return a;
}

- (int)method2:(int)a {
    DEFAULT_LOG;
    return a;
}

- (short)method3:(short)a {
    DEFAULT_LOG;
    return a;
}

- (long)method4:(long)a {
    DEFAULT_LOG;
    return a;
}

- (long long)method5:(long long)a {
    DEFAULT_LOG;
    return a;
}

- (unsigned char)method6:(unsigned char)a {
    DEFAULT_LOG;
    return a;
}

- (unsigned int)method7:(unsigned int)a {
    DEFAULT_LOG;
    return a;
}

- (unsigned short)method8:(unsigned short)a {
    DEFAULT_LOG;
    return a;
}

- (unsigned long)method9:(unsigned long)a {
    DEFAULT_LOG;
    return a;
}

- (unsigned long long)method10:(unsigned long long)a {
    DEFAULT_LOG;
    return a;
}

- (float)method11:(float)a  {
    DEFAULT_LOG;
    return a;
}

- (double)method12:(double)a {
    DEFAULT_LOG;
    return a;
}

- (BOOL)method13:(BOOL)a {
    DEFAULT_LOG;
    return a;
}

- (void)method14 {
    DEFAULT_LOG;
}

- (char *)method15:(char *)a {
    DEFAULT_LOG;
    return a;
}

- (id)method16:(id)a {
    DEFAULT_LOG;
    return a;
}

- (Class)method17:(Class)a {
    DEFAULT_LOG;
    return a;
}

- (SEL)method18:(SEL)a {
    DEFAULT_LOG;
    return a;
}

- (CGRect)method19:(CGRect)a {
    DEFAULT_LOG;
    return a;
}

- (CGPoint)method20:(CGPoint)a {
    DEFAULT_LOG;
    return a;
}

- (CGSize)method21:(CGSize)a {
    DEFAULT_LOG;
    return a;
}

- (CGVector)method22:(CGVector)a {
    DEFAULT_LOG;
    return a;
}

- (CGAffineTransform)method23:(CGAffineTransform)a {
    DEFAULT_LOG;
    return a;
}

- (UIEdgeInsets)method24:(UIEdgeInsets)a {
    DEFAULT_LOG;
    return a;
}

- (UIOffset)method25:(UIOffset)a {
    DEFAULT_LOG;
    return a;
}

- (NSString *)method26:(NSString *)a {
    DEFAULT_LOG;
    return a;
}

- (void (^)())method27:(void (^)())a {
    DEFAULT_LOG;
    return a;
}

@end


#pragma mark -

@interface ANYMethodLogDemoTests : XCTestCase

@end


@implementation ANYMethodLogDemoTests

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

- (void)testMyObject {
    [ANYMethodLog logMethodWithClass:[MyObject class] condition:^BOOL(SEL sel) {
        return YES;
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        NSLog(@"target:%@ sel:%@ args:%@", target, NSStringFromSelector(sel), args);
    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
        
    }];
    
    MyObject *o = [[MyObject alloc] init];
    
    XCTAssertTrue([o methodWithA:'a'
                               b:1
                               c:12
                               d:123
                               e:1234
                               f:'u'
                               g:3
                               h:4
                               i:5
                               j:6
                               k:7.1
                               l:7.12345
                               m:YES
                               o:"hello"
                               p:o
                               q:[o class]
                               r:NSSelectorFromString(@"viewDidLoad")
                               s:CGRectMake(1.1, 1.2, 1.3, 1.4)
                               t:CGPointMake(2.11, 2.12)
                               u:CGSizeMake(3.123, 3.1234)
                               v:CGVectorMake(4.456, 4.567)
                               w:CGAffineTransformMake(6.123, 6.124, 6.125, 6.126, 6.127, 6.128)
                               x:UIOffsetMake(7.123456, 7.1234567)
                               y:UIEdgeInsetsMake(8.0, 8.0001, 8.0002, 8.0003)]);
    
    XCTAssertTrue('a' == [o method1:'a']);
    XCTAssertTrue(12 == [o method2:12]);
    XCTAssertTrue(13 == [o method3:13]);
    XCTAssertTrue(1444444 == [o method4:1444444]);
    
    long long ll = 155;
    long long llr = [o method5:ll];
    XCTAssertTrue(ll == llr);
    
    XCTAssertTrue('u' == [o method6:'u']);
    XCTAssertTrue(17 == [o method7:17]);
    XCTAssertTrue(18 == [o method8:18]);
    XCTAssertTrue(19000 == [o method9:19000]);
    XCTAssertTrue(20 == [o method10:20]);
    XCTAssertTrue(21 == [o method11:21]);
    XCTAssertTrue(22.345678 == [o method12:22.345678]);
    XCTAssertTrue(YES == [o method13:YES]);
    XCTAssertTrue(NO == [o method13:NO]);
    [o method14];
    XCTAssertTrue("c255555" == [o method15:"c255555"]);
    XCTAssertTrue(o == [o method16:o]);
    XCTAssertTrue(NSClassFromString(@"MyObject") == [o method17:NSClassFromString(@"MyObject")]);
    XCTAssertTrue(NSSelectorFromString(@"method17:") == [o method18:NSSelectorFromString(@"method17:")]);
    XCTAssertTrue(CGRectEqualToRect(CGRectMake(1.2, 1.23, 1.234, 1.2345), [o method19:CGRectMake(1.2, 1.23, 1.234, 1.2345)]));
    
    XCTAssertTrue(CGPointEqualToPoint(CGPointMake(2.3, 2.34), [o method20:CGPointMake(2.3, 2.34)]));
    XCTAssertTrue(CGSizeEqualToSize(CGSizeMake(3.4, 3.45), [o method21:CGSizeMake(3.4, 3.45)]));
    
    CGVector vector = CGVectorMake(9.234, 9.2345);
    XCTAssertTrue(vector.dx == [o method22:vector].dx && vector.dy == [o method22:vector].dy);
    
    XCTAssertTrue(CGAffineTransformEqualToTransform(CGAffineTransformMake(4.1, 4.12, 4.123, 4.1234, 4.12345, 4.123456),[o method23:CGAffineTransformMake(4.1, 4.12, 4.123, 4.1234, 4.12345, 4.123456)]));
    
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsMake(5.1, 5.12, 5.123, 5.1234), [o method24:UIEdgeInsetsMake(5.1, 5.12, 5.123, 5.1234)]));
    
    XCTAssertTrue(UIOffsetEqualToOffset(UIOffsetMake(6.123, 6.1234),[o method25:UIOffsetMake(6.123, 6.1234)]));
    
    XCTAssertTrue([@"hello" isEqualToString:[o method26:@"hello"]]);
    
    void (^aBlock)() = ^() {
        
    };
    XCTAssertTrue(aBlock == [o method27:aBlock]);
}

@end
