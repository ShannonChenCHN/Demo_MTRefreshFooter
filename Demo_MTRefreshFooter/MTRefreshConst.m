//
//  MTRefreshConst.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "MTRefreshConst.h"

const CGFloat MTRefreshHeaderHeight = 54.0;
const CGFloat MTRefreshFooterHeight = 44.0;
const CGFloat MTRefreshFastAnimationDuration = 0.25;
const CGFloat MTRefreshSlowAnimationDuration = 0.4;


NSString *const MTRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MTRefreshKeyPathContentInset = @"contentInset";
NSString *const MTRefreshKeyPathContentSize = @"contentSize";
NSString *const MTRefreshKeyPathPanState = @"state";

NSString *const MTRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const MTRefreshHeaderPullingText = @"松开立即刷新";
NSString *const MTRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const MTRefreshAutoFooterIdleText = @"上拉加载更多";
NSString *const MTRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const MTRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";
