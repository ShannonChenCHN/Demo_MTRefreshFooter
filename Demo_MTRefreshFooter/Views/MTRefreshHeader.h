//
//  MTRefreshHeader.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/24.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "UIView+MTExtension.h"
#import "MTRefreshConst.h"

typedef void (^MTRefreshActionHandler)(); // 刷新回调block

@interface MTRefreshHeader : UIView


@property (nonatomic, assign) MTRefreshState state; ///< the state of loading

@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@property (nonatomic, copy, nullable) MTRefreshActionHandler refreshingBlock;

@property (assign, nonatomic) CGFloat pullingPercent;


+ (nonnull instancetype)headerWithRefreshingHandler:(__nullable MTRefreshActionHandler)handler;

- (void)startRefreshing;

- (void)finishRefreshing;

@end
