# ANYMethodLog    打印任何方法


###调用说明:

    + (void)logMethodWithClass:(Class)aClass
                     condition:(BOOL(^)(SEL sel))condition
                        before:(void(^)(id target, SEL sel))before
                         after:(void(^)(id target, SEL sel))after;

aClass:目标类
condition:是否打印某个方法
before:某个方法调用前
before:某个方法调用后


###功能：
1.打印一个类的所有方法：

    [ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
        NSLog(@"method:%@", NSStringFromSelector(sel));
        return NO;
    } before:nil after:nil];


2.追踪方法的调用栈，并且可以只追踪限定的方法：

    [ANYMethodLog logMethodWithClass:[UIViewController class] condition:^BOOL(SEL sel) {
        
        NSArray *whiteList = @[@"loadView", @"viewDidLoad", @"viewWillAppear:", @"viewDidAppear:", @"viewWillDisappear:", @"viewDidDisappear:", @"viewWillLayoutSubviews", @"viewDidLayoutSubviews"];
        return [whiteList containsObject:NSStringFromSelector(sel)];
        
    } before:^(id target, SEL sel) {
        
        NSLog(@"before target:%@ sel:%@", target, NSStringFromSelector(sel));
        
    } after:^(id target, SEL sel) {
        
        NSLog(@"after target:%@ sel:%@", target, NSStringFromSelector(sel));
        
    }];


3.观测某个方法调用前与调用后的变化：

    [ANYMethodLog logMethodWithClass:[ListController class] condition:^BOOL(SEL sel) {
        
        return [NSStringFromSelector(sel) isEqualToString:@"viewDidLoad"];
        
    } before:^(id target, SEL sel) {
        
        NSLog(@"before frame%@", NSStringFromCGRect([(ListController *)target view].frame));
    
    } after:^(id target, SEL sel) {
        
        NSLog(@"after frame%@", NSStringFromCGRect([(ListController *)target view].frame));
        
    }];


###TODO：

+ 解决真机上运行出现的问题。
+ 打印调用时的参数值。
+ 打印返回值。
+ 追踪类方法。
+ 追踪父类的方法。
+ 计算某个方法的耗时。


###原理：

利用runtime交换方法的实现。动态创建新方法，在新方法里再调用原来的方法。现阶段还不是很完美地调用原来方法，在需要传参的方法会出现传参失败，在真机问题较多，在模拟器问题较少，在用的时候可以过滤掉需要传参的方法。




