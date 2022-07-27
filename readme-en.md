# ANYMethodLog - log any method call of object in Objective-C  
[中文](../master/README.md)

Print any method in an Objective-C object with ANYMethodLog

![running show](Documentation/Images/running_show.gif)
  
## How to call:  

```objective-c
+ (void)logMethodWithClass:(Class)aClass
                 condition:(BOOL(^)(SEL sel)) condition
                    before:(void(^)(id target, SEL sel, NSArray *args, int deep)) before
                     after:(void(^)(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue)) after;
```

aClass：The class to be logged

condition：Whether or not to track the method according to this block (sel is the method name)

before：block will be called before the method (target is the detected object, sel is the method name, args is the parameter list, and deep is the calling level)

after：block will be called after the method (interval is time spent executing the method, and retValue is the return value)

## Functionality：
1. Print all methods defined by a class, including public and private methods:

```objective-c
[ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
    NSLog(@"method:%@", NSStringFromSelector(sel));
    return NO;
} before:nil after:nil];
```

2. Print which methods are called during the run:

```objective-c
[ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
    return YES;
} before:^(id target, SEL sel, NSArray *args, int deep) {
    NSLog(@"target:%@ sel:%@", target, NSStringFromSelector(sel));
} after:nil];
```

3. Print the calling sequence of specific methods:

```objective-c
[ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
    
    NSArray *whiteList = @[@"loadView", @"viewWillAppear:", @"viewDidAppear:", @"viewWillDisappear:", @"viewDidDisappear:", @"viewWillLayoutSubviews", @"viewDidLayoutSubviews"];
    return [whiteList containsObject:NSStringFromSelector(sel)];
    
} before:^(id target, SEL sel, NSArray *args, int deep) {
    
    NSLog(@"target:%@ sel:%@", target, NSStringFromSelector(sel));
    
} after:nil];
```

4. Print the parameter values when calling the method:

```objective-c
[ANYMethodLog logMethodWithClass:NSClassFromString(@"UIViewController") condition:^BOOL(SEL sel) {
    
    return [NSStringFromSelector(sel) isEqualToString:@"viewWillAppear:"];

} before:^(id target, SEL sel, NSArray *args, int deep) {

    NSLog(@"before target:%@ sel:%@ args:%@", target, NSStringFromSelector(sel), args);

} after:nil];
```

5. Print the changes before and after a method call:

```objective-c
[ANYMethodLog logMethodWithClass:NSClassFromString(@"ListController") condition:^BOOL(SEL sel) {

    return [NSStringFromSelector(sel) isEqualToString:@"changeBackground"];

} before:^(id target, SEL sel, NSArray *args, int deep) {

    NSLog(@"before background color:%@", [(ListController *)target view].backgroundColor);

} after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
    
    NSLog(@"after background color:%@", [(ListController *)target view].backgroundColor);
    
}];
```

6. Print the time elapsed for a method call:：  

```objective-c
[ANYMethodLog logMethodWithClass:NSClassFromString(@"ListController") condition:^BOOL(SEL sel) {
    
    return [NSStringFromSelector(sel) isEqualToString:@"changeBackground"];
    
} before:^(id target, SEL sel, NSArray *args, int deep) {
    
    
} after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
    
    NSLog(@"interval::%@", [@(interval) stringValue]);
    
}];
```

7. Trace the method call sequence:： 

```objective-c
[ANYMethodLog logMethodWithClass:NSClassFromString(@"ListController") condition:^BOOL(SEL sel) {
    return  YES;
} before:^(id target, SEL sel, NSArray *args, int deep) {
    NSString *selector = NSStringFromSelector(sel);
    NSArray *selectorArrary = [selector componentsSeparatedByString:@":"];
    selectorArrary = [selectorArrary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    NSMutableString *selectorString = [NSMutableString new];
    for (int i = 0; i < selectorArrary.count; i++) {
        [selectorString appendFormat:@"%@:%@ ", selectorArrary[i], args[i]];
    }
    NSMutableString *deepString = [NSMutableString new];
    for (int i = 0; i < deep; i++) {
        [deepString appendString:@"-"];
    }
    NSLog(@"%@[%@ %@]", deepString , target, selectorString);
} after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
    NSMutableString *deepString = [NSMutableString new];
    for (int i = 0; i < deep; i++) {
        [deepString appendString:@"-"];
    }
    NSLog(@"%@ret:%@", deepString, retValue);
}];
```

## TODO：  

+ Solving the problem of running on real machines. (completed)
+ Printing the parameter value at the time of the call. (completed)
+ Printing the return value. (completed)
+ Calculating the time taken for a method. (completed)

## Implementation：  

1. Replace the `IMP` of the original method with `_objc_msgForward` to trigger the `forwardInvocation` method;

2. Replace the `IMP` of the method `forwardInvocation` with `qhd_forwardInvocation`

3. Create a new method, `IMP` overwrites the original method, then just call the new method in `qhd_forwardInvocation`. Then you can insert log in `qhd_forwardInvocation`.

Issues and Pull requests are welcome

