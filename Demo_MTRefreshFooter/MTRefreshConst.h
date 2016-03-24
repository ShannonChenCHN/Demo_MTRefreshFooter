//
//  MTRefreshConst.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, MTRefreshState) {
    MTRefreshStateIdle = 1,     ///<  普通闲置状态
    MTRefreshStatePulling,      ///< 松开就可以进行刷新的状态
    MTRefreshStateRefreshing,   ///< 正在刷新中的状态
    MTRefreshStateWillRefresh,  ///< 即将刷新的状态
    MTRefreshStateNoMoreData    ///< 所有数据加载完毕，没有更多的数据了
};

UIKIT_EXTERN const CGFloat MTRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat MTRefreshFooterHeight;
UIKIT_EXTERN const CGFloat MTRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat MTRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const MTRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const MTRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const MTRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const MTRefreshKeyPathPanState;


UIKIT_EXTERN NSString *const MTRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const MTRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const MTRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const MTRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const MTRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const MTRefreshAutoFooterNoMoreDataText;


// RGB颜色
#define MTRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define MTRefreshLabelTextColor MTRefreshColor(90, 90, 90)

// 字体大小
#define MTRefreshLabelFont [UIFont boldSystemFontOfSize:14]