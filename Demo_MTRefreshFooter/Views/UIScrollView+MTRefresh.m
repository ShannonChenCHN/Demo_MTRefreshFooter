//
//  UIScrollView+MTRefresh.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "UIScrollView+MTRefresh.h"
#import <objc/runtime.h>

#pragma mark - method swizzling
@implementation NSObject (MTRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end


@implementation UIScrollView (MTRefresh)

static const char MTRefreshFooterKey = '\0';
- (void)setMt_footer:(MTRefreshFooter *)mt_footer
{
    if (mt_footer != self.mt_footer) {
        // 删除旧的，添加新的
        [self.mt_footer removeFromSuperview];
        [self addSubview:mt_footer];
        
        // 存储新的
        [self willChangeValueForKey:@"mt_footer"]; // KVO
        objc_setAssociatedObject(self, &MTRefreshFooterKey,
                                 mt_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"mt_footer"]; // KVO
    }
}

- (MTRefreshFooter *)mt_footer
{
    return objc_getAssociatedObject(self, &MTRefreshFooterKey);
}




@end
