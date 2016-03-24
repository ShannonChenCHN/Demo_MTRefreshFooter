//
//  MTRefreshFooter.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/16.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "UIView+MTExtension.h"
#import "MTRefreshConst.h"



typedef void (^MTRefreshActionHandler)(); // 刷新回调block

@interface MTRefreshFooter : UIView

@property (nonatomic, assign) MTRefreshState state; ///< the state of loading

@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@property (nonatomic, copy, nullable) MTRefreshActionHandler refreshHandler;

/**
 *  Create and return an footer with the specified behavior.
 *
 *  @param handler A block to execute when the user triggers the refresh action.This block has no return value and parameter.
 *
 *  @return A new footer object for showing refresh state.
 */
+ (nonnull instancetype)footerWithRefreshingHandler:(__nullable MTRefreshActionHandler)handler;

/**
 *  Automatically make some changes on UI, start animations and reload data for UITableView or UICollectionView, when loading action is triggered.
 */
- (void)startRefreshing;
/**
 *  Automatically reset UI and stop animations when data loading is finished.
 */
- (void)finishRefreshing;

/**
 *  Automatically stop animations and show "no more data" message when data loading is finished.
 */
- (void)finishRefreshingWithNoMoreData;

@end
