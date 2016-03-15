//
//  UIViewController+MTExtension.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "UIViewController+MTExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (MTExtension)


#pragma mark - Method Swizzling
+ (void)load {
    
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(mt_deallocSwizzling));
    method_exchangeImplementations(method1, method2);
}

- (void)mt_deallocSwizzling {
    NSLog(@"%@ 被销毁了", self);
    
    [self mt_deallocSwizzling];
}


#pragma mark - Associated Object
static char kMethodNameKey;
- (void)setMethodName:(NSString *)methodName {
    objc_setAssociatedObject(self, &kMethodNameKey, methodName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)methodName {
    return objc_getAssociatedObject(self, &kMethodNameKey);
}

@end
