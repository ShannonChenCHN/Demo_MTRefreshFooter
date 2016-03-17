//
//  UIScrollView+MTRefresh.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "UIScrollView+MTRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (MTExtension)

- (void)setMt_insetT:(CGFloat)mt_insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = mt_insetT;
    self.contentInset = inset;
}

- (CGFloat)mt_insetT {
    return self.contentInset.top;
}

- (void)setMt_insetB:(CGFloat)mt_insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = mt_insetB;
    self.contentInset = inset;
}

- (CGFloat)mt_insetB {
    return self.contentInset.bottom;
}

- (void)setMt_insetL:(CGFloat)mt_insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = mt_insetL;
    self.contentInset = inset;
}

- (CGFloat)mt_insetL {
    return self.contentInset.left;
}

- (void)setMt_insetR:(CGFloat)mt_insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = mt_insetR;
    self.contentInset = inset;
}

- (CGFloat)mt_insetR {
    return self.contentInset.right;
}

- (void)setMt_offsetX:(CGFloat)mt_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = mt_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)mt_offsetX {
    return self.contentOffset.x;
}

- (void)setMt_offsetY:(CGFloat)mt_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = mt_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)mt_offsetY {
    return self.contentOffset.y;
}

- (void)setMt_contentW:(CGFloat)mt_contentW {
    CGSize size = self.contentSize;
    size.width = mt_contentW;
    self.contentSize = size;
}

- (CGFloat)mt_contentW {
    return self.contentSize.width;
}

- (void)setMt_contentH:(CGFloat)mt_contentH {
    CGSize size = self.contentSize;
    size.height = mt_contentH;
    self.contentSize = size;
}

- (CGFloat)mt_contentH {
    return self.contentSize.height;
}

@end

//___________________________________________________________________________________________________

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
