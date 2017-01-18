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
    // Override point for customization after application launch.
    
    //用法一
//    [ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
//        NSLog(@"method:%@", NSStringFromSelector(sel));
//        return NO;
//    } before:nil after:nil];

    
    //用法二
    [ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
        
        NSArray *whiteList = @[@"loadView", @"viewDidLoad", @"viewWillAppear:", @"viewDidAppear:", @"viewWillDisappear:", @"viewDidDisappear:", @"viewWillLayoutSubviews", @"viewDidLayoutSubviews"];
        return [whiteList containsObject:NSStringFromSelector(sel)];
        
    } before:^(id target, SEL sel) {
        
        NSLog(@"before target:%@ sel:%@", target, NSStringFromSelector(sel));
        
    } after:^(id target, SEL sel) {
        
        NSLog(@"after target:%@ sel:%@", target, NSStringFromSelector(sel));
        
    }];
    
    //用法三
//    [ANYMethodLog logMethodWithClass:[ListController class] condition:^BOOL(SEL sel) {
//        
//        return [NSStringFromSelector(sel) isEqualToString:@"viewDidLoad"];
//        
//    } before:^(id target, SEL sel) {
//        
//        NSLog(@"before frame%@", NSStringFromCGRect([(ListController *)target view].frame));
//    
//    } after:^(id target, SEL sel) {
//        
//        NSLog(@"after frame%@", NSStringFromCGRect([(ListController *)target view].frame));
//        
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
