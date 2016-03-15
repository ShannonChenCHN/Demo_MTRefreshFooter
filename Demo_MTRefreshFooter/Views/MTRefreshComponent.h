//
//  MTRefreshComponent.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+MTExtension.h"
#import "UIView+MTExtension.h"
#import "MTRefreshConst.h"

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, MTRefreshState) {
    /** 普通闲置状态 */
    MTRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    MTRefreshStatePulling,
    /** 正在刷新中的状态 */
    MTRefreshStateRefreshing,
    /** 即将刷新的状态 */
    MTRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    MTRefreshStateNoMoreData
};

@interface MTRefreshComponent : UIView


@property (nonatomic, assign) MTRefreshState state;

@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

#pragma mark - 子类去实现
- (void)prepareForInitialization NS_REQUIRES_SUPER; // 初始化配置

- (void)layoutRefreshSubviews NS_REQUIRES_SUPER; // 布局子控件

@end
