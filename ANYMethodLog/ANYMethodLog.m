//
//  ANYMethodLog.m
//  ANYMethodLog
//
//  Created by qiuhaodong on 2017/1/14.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/ANYMethodLog.git
//

/*经实践打印出不同类型占的长度，放此以方便调试查看
 +---------------------------+------------+------------+--------+
 | type                      |  value(32) |  value(64) |  comp  |
 |---------------------------|------------|------------|--------|
 | sizeof(char)              |     1      |    1       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(int)               |     4      |    4       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(short)             |     2      |    2       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(long)              |     4      |    8       |   *    |
 |---------------------------|------------|------------|--------|
 | sizeof(long long)         |     8      |    8       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(unsigned char)     |     1      |    1       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(unsigned int)      |     4      |    4       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(unsigned short)    |     2      |    2       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(unsigned long)     |     4      |    8       |   *    |
 |---------------------------|------------|------------|--------|
 | sizeof(unsigned long long)|     8      |    8       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(float)             |     4      |    4       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(double)            |     8      |    8       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(BOOL)              |     1      |    1       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(void)              |     1      |    1       |        |
 |---------------------------|------------|------------|--------|
 | sizeof(char*)             |     4      |    8       |   *    |
 |---------------------------|------------|------------|--------|
 | sizeof(id)                |     4      |    8       |   *    |
 |---------------------------|------------|------------|--------|
 | sizeof(Class)             |     4      |    8       |   *    |
 |---------------------------|------------|------------|--------|
 | sizeof(SEL)               |     4      |    8       |   *    |
 +---------------------------+------------+------------+--------+
 */

#import "ANYMethodLog.h"
#include <objc/runtime.h>
#import <UIKit/UIKit.h>

#pragma mark - AMLBlock

@interface AMLBlock : NSObject

@property (strong, nonatomic) NSString *targetClassName;
@property (copy, nonatomic) BOOL(^condition)(SEL sel);
@property (copy, nonatomic) void(^before)(id target, SEL sel);
@property (copy, nonatomic) void(^after)(id target, SEL sel);

@end

@implementation AMLBlock

- (BOOL)runCondition:(SEL)sel {
    if (self.condition) {
        return self.condition(sel);
    } else {
        return YES;
    }
}

- (void)rundBefore:(id)target sel:(SEL)sel {
    if (self.before) {
        self.before(target, sel);
    }
}

- (void)rundAfter:(id)target sel:(SEL)sel {
    if (self.after) {
        self.after(target, sel);
    }
}

@end


#pragma mark - ANYMethodLog private interface

@interface ANYMethodLog()

@property (strong, nonatomic) NSMutableDictionary *blockCache;

+ (instancetype)sharedANYMethodLog;

- (AMLBlock *)blockWithTarget:(id)target;

@end


#pragma mark - C function

#define SHARED_ANYMETHODLOG [ANYMethodLog sharedANYMethodLog]

//#define OPEN_TARGET

#ifdef OPEN_TARGET
#define TARGET_LOG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define TARGET_LOG(format, ...)
#endif


//#define OPEN_DEV_LOG

#ifdef OPEN_DEV_LOG
#define DEV_LOG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define DEV_LOG(format, ...)
#endif

//是否在默认的黑名单中
BOOL qhd_isInBlackList(NSString *methodName) {
    static NSArray *defaultBlackList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultBlackList = @[/*UIViewController的:*/@".cxx_destruct", @"dealloc", @"_isDeallocating", @"release", @"autorelease", @"retain", @"Retain", @"_tryRetain", @"copy", /*UIView的:*/ @"nsis_descriptionOfVariable:", /*NSObject的:*/@"respondsToSelector:", @"class", @"methodSignatureForSelector:", @"allowsWeakReference", @"retainWeakReference", @"init"];
    });
    return ([defaultBlackList containsObject:methodName]);
}

/*reference: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 经实践发现与文档有差别
 1.在64位时@encode(long)跟@encode(long long)的值一样;
 2.在64位时@encode(unsigned long)跟@encode(unsigned long long)的值一样；
 3.在32位时@encode(BOOL)跟@encode(char)一样。
 +--------------------+-----------+-----------+
 | type               |code(32bit)|code(64bit)|
 |--------------------|-----------|-----------|
 | BOOL               |     c     |    B      |
 |--------------------|-----------|-----------|
 | char               |     c     |    c      |
 |--------------------|-----------|-----------|
 | long               |     l     |    q      |
 |--------------------|-----------|-----------|
 | long long          |     q     |    q      |
 |--------------------|-----------|-----------|
 | unsigned long      |     L     |    Q      |
 |--------------------|-----------|-----------|
 | unsigned long long |     Q     |    Q      |
 +--------------------+-----------+-----------+
 */
NSDictionary *qhd_canHandleTypeDic() {
    static NSDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{[NSString stringWithUTF8String:@encode(char)] : @"(char)",
                [NSString stringWithUTF8String:@encode(int)] : @"(int)",
                [NSString stringWithUTF8String:@encode(short)] : @"(short)",
                [NSString stringWithUTF8String:@encode(long)] : @"(long)",
                [NSString stringWithUTF8String:@encode(long long)] : @"(long long)",
                [NSString stringWithUTF8String:@encode(unsigned char)] : @"(unsigned char))",
                [NSString stringWithUTF8String:@encode(unsigned int)] : @"(unsigned int)",
                [NSString stringWithUTF8String:@encode(unsigned short)] : @"(unsigned short)",
                [NSString stringWithUTF8String:@encode(unsigned long)] : @"(unsigned long)",
                [NSString stringWithUTF8String:@encode(unsigned long long)] : @"(unsigned long long)",
                [NSString stringWithUTF8String:@encode(float)] : @"(float)",
                [NSString stringWithUTF8String:@encode(double)] : @"(double)",
                [NSString stringWithUTF8String:@encode(BOOL)] : @"(BOOL)",
                [NSString stringWithUTF8String:@encode(void)] : @"(void)",
                [NSString stringWithUTF8String:@encode(char *)] : @"(char *)",
                [NSString stringWithUTF8String:@encode(id)] : @"(id)",
                [NSString stringWithUTF8String:@encode(Class)] : @"(Class)",
                [NSString stringWithUTF8String:@encode(SEL)] : @"(SEL)",
                [NSString stringWithUTF8String:@encode(CGRect)] : @"(CGRect)",
                [NSString stringWithUTF8String:@encode(CGPoint)] : @"(CGPoint)",
                [NSString stringWithUTF8String:@encode(CGSize)] : @"(CGSize)",
                [NSString stringWithUTF8String:@encode(CGVector)] : @"(CGVector)",
                [NSString stringWithUTF8String:@encode(CGAffineTransform)] : @"(CGAffineTransform)",
                [NSString stringWithUTF8String:@encode(UIOffset)] : @"(UIOffset)",
                [NSString stringWithUTF8String:@encode(UIEdgeInsets)] : @"(UIEdgeInsets)"
                };//TODO:添加其他类型
    });
    return dic;
}

//根据定义的类型的判断是否能处理
BOOL qhd_isCanHandle(NSString *typeEncode) {
    return [qhd_canHandleTypeDic().allKeys containsObject:typeEncode];
}

//交换方法实现
void qhd_exchangeInstanceMethod(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if(class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

//创建一个新的selector
SEL qhd_createNewSelector(SEL originalSelector) {
    NSString *oldSelectorName = NSStringFromSelector(originalSelector);
    NSString *newSelectorName = [NSString stringWithFormat:@"qhd_%@", oldSelectorName];
    SEL newSelector = NSSelectorFromString(newSelectorName);
    return newSelector;
}

//是否struct类型
BOOL qhd_isStructType(const char *argumentType) {
    NSString *typeString = [NSString stringWithUTF8String:argumentType];
    return ([typeString hasPrefix:@"{"] && [typeString hasSuffix:@"}"]);
}

//struct类型名
NSString *qhd_structName(const char *argumentType) {
    NSString *typeString = [NSString stringWithUTF8String:argumentType];
    NSUInteger start = [typeString rangeOfString:@"{"].location;
    NSUInteger end = [typeString rangeOfString:@"="].location;
    if (end > start) {
        return [typeString substringWithRange:NSMakeRange(start + 1, end - start - 1)];
    } else {
        return nil;
    }
}

BOOL isCGRect           (const char *type) {return [qhd_structName(type) isEqualToString:@"CGRect"];}
BOOL isCGPoint          (const char *type) {return [qhd_structName(type) isEqualToString:@"CGPoint"];}
BOOL isCGSize           (const char *type) {return [qhd_structName(type) isEqualToString:@"CGSize"];}
BOOL isCGVector         (const char *type) {return [qhd_structName(type) isEqualToString:@"CGVector"];}
BOOL isUIOffset         (const char *type) {return [qhd_structName(type) isEqualToString:@"UIOffset"];}
BOOL isUIEdgeInsets     (const char *type) {return [qhd_structName(type) isEqualToString:@"UIEdgeInsets"];}
BOOL isCGAffineTransform(const char *type) {return [qhd_structName(type) isEqualToString:@"CGAffineTransform"];}

//设置struct类型的参数
void qhd_setStructArguments(NSInvocation *invocation, const char *argumentType, va_list vas, NSInteger index, NSMutableString **methodDesc) {
    if (isCGRect(argumentType)) {
        CGRect rect = va_arg(vas, CGRect);
        [invocation setArgument:&rect atIndex:index];
        [*methodDesc appendFormat:@"%@ ", NSStringFromCGRect(rect)];
    }
    
    else if (isCGPoint(argumentType)
             || isCGSize(argumentType)
             || isCGVector(argumentType)
             || isUIOffset(argumentType)) {
        CGPoint point = va_arg(vas, CGPoint);
        [invocation setArgument:&point atIndex:index];
        [*methodDesc appendFormat:@"%@ ", NSStringFromCGPoint(point)];
    }
    
    else if (isUIEdgeInsets(argumentType)) {
        UIEdgeInsets edgeInsets = va_arg(vas, UIEdgeInsets);
        [invocation setArgument:&edgeInsets atIndex:index];
        [*methodDesc appendFormat:@"%@ ", NSStringFromUIEdgeInsets(edgeInsets)];
    }
    
    else if (isCGAffineTransform(argumentType)) {
        CGAffineTransform affineTransform = va_arg(vas, CGAffineTransform);
        [invocation setArgument:&affineTransform atIndex:index];
        [*methodDesc appendFormat:@"%@ ", NSStringFromCGAffineTransform(affineTransform)];
    }
    
    else {
        //TODO:添加其他类型
    }
}

#define SET_ARGUMENT(_type,_sizeType,_fmt)        \
    else if (0 == strcmp(type, @encode(_type))) { \
        _type arg = va_arg(vas, _sizeType);       \
        [invocation setArgument:&arg atIndex:i];  \
        [methodDesc appendFormat:_fmt, arg];      \
    }

//设置invocation参数
NSString *qhd_setArguments(NSInvocation *invocation, NSMethodSignature *signature, va_list vas, SEL sel) {
    NSString *origionSlectorName = NSStringFromSelector(sel);
    NSArray *partNameList = [origionSlectorName componentsSeparatedByString:@":"];
    NSMutableString *methodDesc = [NSMutableString string];
    
    NSUInteger argsCount = signature.numberOfArguments;
    for (NSUInteger i = 2 ; i < argsCount; i ++) {
        const char *type = [signature getArgumentTypeAtIndex:i];
        
        NSUInteger nIndex = i - 2;
        NSString *partName = partNameList[nIndex];
        NSDictionary *dictionary = qhd_canHandleTypeDic();
        NSString *key = [NSString stringWithUTF8String:type];
        NSString *value = [dictionary objectForKey:key];
        [methodDesc appendFormat:@"%@:%@", partName, value];
        
        if (qhd_isStructType(type)) {
            qhd_setStructArguments(invocation, type, vas, i, &methodDesc);
        }
        //注意在32位与在64位有个别类型长度不同，所以会有警告
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wvarargs"
        SET_ARGUMENT(char, char, @"%c ") //注意
        SET_ARGUMENT(int, int, @"%d ")
        SET_ARGUMENT(short, short, @"%d ") //注意
        SET_ARGUMENT(long, long, @"%ldL ")
        SET_ARGUMENT(long long, long long, @"%lldLL ")
        SET_ARGUMENT(unsigned char, unsigned char, @"%c ")//注意
        SET_ARGUMENT(unsigned int, unsigned int, @"%d ")
        SET_ARGUMENT(unsigned short, unsigned short, @"%d ")//注意
        SET_ARGUMENT(unsigned long, unsigned long, @"%luL ")
        SET_ARGUMENT(unsigned long long, unsigned long long, @"%lluLL ")
        SET_ARGUMENT(float, float, @"%f ")//注意
        SET_ARGUMENT(double, double, @"%f ")
        SET_ARGUMENT(BOOL, BOOL, @"%d ")//注意
        #pragma clang diagnostic pop
        SET_ARGUMENT(char *, char *, @"%s ")
        SET_ARGUMENT(id, id, @"%@ ")
        SET_ARGUMENT(Class, Class, @"%@ ")
        else if (0 == strcmp(type, @encode(SEL))) {
            SEL arg = va_arg(vas, SEL);
            [invocation setArgument:&arg atIndex:i];
            [methodDesc appendFormat:@"%@ ", NSStringFromSelector(arg)];
        }
        SET_ARGUMENT(void *, void *, @"%@ ")
    }
    if (methodDesc.length <= 0) {
        [methodDesc appendString:origionSlectorName];
    }
    return methodDesc;
}

//调用原方法
NSInvocation *qhd_callOrigionMethod(id target, SEL sel, va_list vas, void **returnValue, BOOL hasReturn, NSString **desc) {
    SEL newSelecor = qhd_createNewSelector(sel);
    NSMethodSignature *signature = [target methodSignatureForSelector:newSelecor];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = newSelecor;
    
    NSString *methodDesc = qhd_setArguments(invocation, signature, vas, sel);
    *desc = methodDesc;
    
    AMLBlock *block = [SHARED_ANYMETHODLOG blockWithTarget:target];
    [block rundBefore:target sel:sel];
    
    [invocation invoke];
    
    [block rundAfter:target sel:sel];
    
    if (hasReturn) {
        NSUInteger length = [signature methodReturnLength];
        void *buffer = (void *)malloc(length);
        memset(buffer, 0, length);
        [invocation getReturnValue:&buffer];
        (*returnValue) = buffer;
    }
    return invocation;
}

#define BEGIN_CALL       \
    TARGET_LOG(@"begin id:%@ m:%@", target, NSStringFromSelector(_cmd));\
    va_list vas;         \
    va_start(vas, _cmd); \
    NSString *desc;

#define END_CALL \
    va_end(vas); \
    //TARGET_LOG(@"end id:%@ m:%@", target, desc);

#define CALL_NO_RETURN  \
qhd_callOrigionMethod(target, _cmd, vas, NULL, NO, &desc)

//无返回值的函数
void qhd_function(id target, SEL _cmd, ...) {
    BEGIN_CALL
    CALL_NO_RETURN;
    END_CALL
}

//返回通用类型(不包含float, double, BOOL, longlong, unsignedlonglong, ustruct)的函数
void *qhd_function_r(id target, SEL _cmd, ...) {
    BEGIN_CALL
    void *returnValue = NULL;
    qhd_callOrigionMethod(target, _cmd, vas, &returnValue, YES, &desc);
    END_CALL
    return returnValue;
}

//因为在32位返回类型是long long的时候获取返回值有问题，所以要具体定义
long long qhd_function_longlong(id target, SEL _cmd, ...) {
    BEGIN_CALL
    long long returnValue;
    [CALL_NO_RETURN getReturnValue:&returnValue];
    END_CALL
    return returnValue;
}

//因为在32位返回类型是unsigned long long的时候获取返回值有问题，所以要具体定义
unsigned long long qhd_function_unsignedlonglong(id target, SEL _cmd, ...) {
    BEGIN_CALL
    unsigned long long returnValue;
    [CALL_NO_RETURN getReturnValue:&returnValue];
    END_CALL
    return returnValue;
}

//函数名
#define FUN_NAME(_type) qhd_function_##_type

//函数声明
#define FUN_DECLARATION(_type) _type FUN_NAME(_type)

//函数定义
#define FUN_DEFINITION(_type)                          \
    FUN_DECLARATION(_type)(id target, SEL _cmd, ...) { \
        BEGIN_CALL                                     \
        _type returnValue;                             \
        [CALL_NO_RETURN getReturnValue:&returnValue];  \
        END_CALL                                       \
        return returnValue;                            \
    }

//返回BOOL的函数
FUN_DEFINITION(BOOL)

//返回float的函数
FUN_DEFINITION(float)

//返回double的函数
FUN_DEFINITION(double)

//返回CGRect的函数
FUN_DEFINITION(CGRect)

//返回CGPoint的函数 (CGSize, CGVector也是用这个)
FUN_DEFINITION(CGPoint)

//返回UIEdgeInsets的函数
FUN_DEFINITION(UIEdgeInsets)

//返回CGAffineTransform的函数
FUN_DEFINITION(CGAffineTransform)

//根据返回类型返回IMP
IMP qhd_imp(const char *returnType) {
    IMP imp = NULL;
    if (0 == strcmp(returnType, @encode(void))) {
        imp  = (IMP)qhd_function;
    } else if (qhd_isStructType(returnType)) {
        if (isCGRect(returnType)) {
            imp = (IMP)FUN_NAME(CGRect);
        } else if (isCGPoint(returnType) || isCGSize(returnType) || isCGVector(returnType) || isUIOffset(returnType)) {
            imp = (IMP)FUN_NAME(CGPoint);
        } else if (isUIEdgeInsets(returnType)) {
            imp = (IMP)FUN_NAME(UIEdgeInsets);
        } else if (isCGAffineTransform(returnType)) {
            imp = (IMP)FUN_NAME(CGAffineTransform);
        } else {
            //TODO:添加其他类型
        }
    } else {
        if (0 == strcmp(returnType, @encode(float))) {
            imp = (IMP)FUN_NAME(float);
        } else if (0 == strcmp(returnType, @encode(double))) {
            imp = (IMP)FUN_NAME(double);
        } else if (0 == strcmp(returnType, @encode(long long))) {
            imp = (IMP)qhd_function_longlong;
        } else if (0 == strcmp(returnType, @encode(unsigned long long))) {
            imp = (IMP)qhd_function_unsignedlonglong;
        } else if (0 == strcmp(returnType, @encode(BOOL))) {
            imp = (IMP)FUN_NAME(BOOL);
        } else if (qhd_isCanHandle([NSString stringWithUTF8String:returnType])){
            imp  = (IMP)qhd_function_r;
        }
    }
    return imp;
}

//检查是否能处理
BOOL qhd_isCanHook(Method method, const char *returnType) {
    
    //若在黑名单中则不处理
    NSString *selectorName = NSStringFromSelector(method_getName(method));
    if (qhd_isInBlackList(selectorName)) {
        return NO;
    }
    
    NSString *returnTypeString = [NSString stringWithUTF8String:returnType];
    
    BOOL isCanHook = YES;
    if (!qhd_isCanHandle(returnTypeString)) {
        isCanHook = NO;
    }
    for(int k = 2 ; k < method_getNumberOfArguments(method); k ++) {
        char argument[250];
        memset(argument, 0, sizeof(argument));
        method_getArgumentType(method, k, argument, sizeof(argument));
        NSString *argumentString = [NSString stringWithUTF8String:argument];
        if (!qhd_isCanHandle(argumentString)) {
            isCanHook = NO;
            break;
        }
    }
    return isCanHook;
}


#pragma mark - ANYMethodLog implementation

@implementation ANYMethodLog

+ (void)logMethodWithClass:(Class)aClass
                 condition:(BOOL(^)(SEL sel))condition
                    before:(void(^)(id target, SEL sel))before
                     after:(void(^)(id target, SEL sel))after {
    #ifndef DEBUG
        return;
    #endif
    
    if (aClass) {
        AMLBlock *block = [[AMLBlock alloc] init];
        block.targetClassName = NSStringFromClass(aClass);
        block.condition = condition;
        block.before = before;
        block.after = after;
        [SHARED_ANYMETHODLOG.blockCache setObject:block forKey:block.targetClassName];
    }
    
    unsigned int outCount;
    Method *methods = class_copyMethodList(aClass,&outCount);
    
    for (int i = 0; i < outCount; i ++) {
        Method tempMethod = *(methods + i);
        SEL selector = method_getName(tempMethod);
        char *returnType = method_copyReturnType(tempMethod);
        
        BOOL isCan = qhd_isCanHook(tempMethod, returnType);
        
        if (isCan && condition) {
            isCan = condition(selector);
        }
        
        if (isCan) {
            IMP imp = qhd_imp(returnType);
            if (imp) {
                SEL newSelector = qhd_createNewSelector(selector);
                BOOL isAdd = class_addMethod(aClass,newSelector,imp,method_getTypeEncoding(tempMethod));
                if (isAdd) {
                    qhd_exchangeInstanceMethod(aClass, selector, newSelector);
                    DEV_LOG(@"success hook method:%@ types:%s", NSStringFromSelector(selector), method_getDescription(tempMethod)->types);
                } else {
                    DEV_LOG(@"fail method:%@ types:%s", NSStringFromSelector(selector), method_getDescription(tempMethod)->types);
                }
            }
        } else {
            DEV_LOG(@"can not hook method:%@ types:%s", NSStringFromSelector(selector), method_getDescription(tempMethod)->types);
        }
        free(returnType);
    }
    free(methods);
}

+ (instancetype)sharedANYMethodLog {
    static ANYMethodLog *_sharedANYMethodLog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedANYMethodLog = [[self alloc] init];
        _sharedANYMethodLog.blockCache = [NSMutableDictionary dictionary];
    });
    return _sharedANYMethodLog;
}

- (AMLBlock *)blockWithTarget:(id)target {
    Class class = [target class];
    AMLBlock *block = [self.blockCache objectForKey:NSStringFromClass(class)];
    while (block == nil) {
        class = [class superclass];
        if (class == nil) {
            break;
        }
        block = [self.blockCache objectForKey:NSStringFromClass(class)];
    }
    return block;
}

@end
