//
//  UIView+MTExtension.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "UIView+MTExtension.h"

@implementation UIView (MTExtension)

- (void)setMt_x:(CGFloat)mt_x
{
    CGRect frame = self.frame;
    frame.origin.x = mt_x;
    self.frame = frame;
}

- (CGFloat)mt_x
{
    return self.frame.origin.x;
}

- (void)setMt_y:(CGFloat)mt_y
{
    CGRect frame = self.frame;
    frame.origin.y = mt_y;
    self.frame = frame;
}

- (CGFloat)mt_y
{
    return self.frame.origin.y;
}

- (void)setMt_w:(CGFloat)mt_w
{
    CGRect frame = self.frame;
    frame.size.width = mt_w;
    self.frame = frame;
}

- (CGFloat)mt_w
{
    return self.frame.size.width;
}

- (void)setMt_h:(CGFloat)mt_h
{
    CGRect frame = self.frame;
    frame.size.height = mt_h;
    self.frame = frame;
}

- (CGFloat)mt_h
{
    return self.frame.size.height;
}

- (void)setMt_size:(CGSize)mt_size
{
    CGRect frame = self.frame;
    frame.size = mt_size;
    self.frame = frame;
}

- (CGSize)mt_size
{
    return self.frame.size;
}

- (void)setMt_origin:(CGPoint)mt_origin
{
    CGRect frame = self.frame;
    frame.origin = mt_origin;
    self.frame = frame;
}

- (CGPoint)mt_origin
{
    return self.frame.origin;
}


@end
