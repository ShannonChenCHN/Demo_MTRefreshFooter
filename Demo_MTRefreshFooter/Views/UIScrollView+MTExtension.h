//
//  UIScrollView+MTExtension.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MTExtension)

@property (assign, nonatomic) CGFloat mt_insetT;
@property (assign, nonatomic) CGFloat mt_insetB;
@property (assign, nonatomic) CGFloat mt_insetL;
@property (assign, nonatomic) CGFloat mt_insetR;

@property (assign, nonatomic) CGFloat mt_offsetX;
@property (assign, nonatomic) CGFloat mt_offsetY;

@property (assign, nonatomic) CGFloat mt_contentW;
@property (assign, nonatomic) CGFloat mt_contentH;

@end
