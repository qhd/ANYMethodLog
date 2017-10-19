//
//  AppDelegate.m
//  ANYMethodLogDemo
//
//  Created by qiuhaodong on 2017/1/18.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/ANYMethodLog.git
//

#import "AppDelegate.h"
#import "ANYMethodLog.h"
#import "ListController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Usage 1: 打印一个类定义的所有方法，包括公开方法和私有方法
//    [ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
//        NSLog(@"method:%@", NSStringFromSelector(sel));
//        return NO;
//    } before:nil after:nil];
    
    
    // Usage 2: 打印在运行过程中调用了哪些方法
    [ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
        return YES;
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        NSLog(@"target:%@ sel:%@", target, NSStringFromSelector(sel));
    } after:nil];
    
    
    // Usage 3: 打印特定几个方法的调用顺序
//    [ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
//        
//        NSArray *whiteList = @[@"loadView", @"viewWillAppear:", @"viewDidAppear:", @"viewWillDisappear:", @"viewDidDisappear:", @"viewWillLayoutSubviews", @"viewDidLayoutSubviews"];
//        return [whiteList containsObject:NSStringFromSelector(sel)];
//        
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        
//        NSLog(@"target:%@ sel:%@", target, NSStringFromSelector(sel));
//        
//    } after:nil];

    
    // Usage 4: 打印调用方法时的参数值
//    [ANYMethodLog logMethodWithClass:NSClassFromString(@"UIViewController") condition:^BOOL(SEL sel) {
//        
//        return [NSStringFromSelector(sel) isEqualToString:@"viewWillAppear:"];
//    
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//    
//        NSLog(@"before target:%@ sel:%@ args:%@", target, NSStringFromSelector(sel), args);
//    
//    } after:nil];
    
    
    // Usage 5: 打印某个方法调用前后的变化
//    [ANYMethodLog logMethodWithClass:NSClassFromString(@"ListController") condition:^BOOL(SEL sel) {
//
//        return [NSStringFromSelector(sel) isEqualToString:@"changeBackground"];
//
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//
//        NSLog(@"before background color:%@", [(ListController *)target view].backgroundColor);
//
//    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//        
//        NSLog(@"after background color:%@", [(ListController *)target view].backgroundColor);
//        
//    }];
    
    
    // Usage 6: 打印某个方法调用的耗时
//    [ANYMethodLog logMethodWithClass:NSClassFromString(@"ListController") condition:^BOOL(SEL sel) {
//        
//        return [NSStringFromSelector(sel) isEqualToString:@"changeBackground"];
//        
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        
//        
//    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//        
//        NSLog(@"interval::%@", [@(interval) stringValue]);
//        
//    }];
    
    // Usage 7: 打印方法调用跟踪
//    [ANYMethodLog logMethodWithClass:NSClassFromString(@"ListController") condition:^BOOL(SEL sel) {
//        return  YES;
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        NSString *selector = NSStringFromSelector(sel);
//        NSArray *selectorArrary = [selector componentsSeparatedByString:@":"];
//        selectorArrary = [selectorArrary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
//        NSMutableString *selectorString = [NSMutableString new];
//        for (int i = 0; i < selectorArrary.count; i++) {
//            [selectorString appendFormat:@"%@:%@ ", selectorArrary[i], args[i]];
//        }
//        NSMutableString *deepString = [NSMutableString new];
//        for (int i = 0; i < deep; i++) {
//            [deepString appendString:@"-"];
//        }
//        NSLog(@"%@[%@ %@]", deepString , target, selectorString);
//    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//        NSMutableString *deepString = [NSMutableString new];
//        for (int i = 0; i < deep; i++) {
//            [deepString appendString:@"-"];
//        }
//        NSLog(@"%@ret:%@", deepString, retValue);
//    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
