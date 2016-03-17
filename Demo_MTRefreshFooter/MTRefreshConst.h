//
//  MTRefreshConst.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN const CGFloat MTRefreshFooterHeight;
UIKIT_EXTERN const CGFloat MTRefreshFastAnimationDuration;

UIKIT_EXTERN NSString *const MTRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const MTRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const MTRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const MTRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const MTRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const MTRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const MTRefreshAutoFooterNoMoreDataText;


// RGB颜色
#define MTRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define MTRefreshLabelTextColor MTRefreshColor(90, 90, 90)

// 字体大小
#define MTRefreshLabelFont [UIFont boldSystemFontOfSize:14]