//
//  MTRefreshComponent.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "MTRefreshComponent.h"

@interface MTRefreshComponent ()

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation MTRefreshComponent

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareForInitialization]; // 初始化配置
        
        self.state = MTRefreshStateIdle; // 默认初始状态
    }
    return self;
}

- (void)prepareForInitialization {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

// 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutRefreshSubviews];
}

- (void)layoutRefreshSubviews {}

/* When a view is removed from a superview, the system sends willMoveToSuperview: to the view. The parameter is nil.
 * http://stackoverflow.com/questions/25996906/willmovetosuperview-is-called-twice
 */
// 当superview发生改变时调用该方法
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是scrollView且不为空时，不做任何处理
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self scrollViewRemoveObservers]; // 不管newSuperview是不是nil，都要注销观察者
    
    if (newSuperview) {
        self.mt_w = newSuperview.mt_w; // 宽度
        self.mt_x = 0;  // 原点x
        
        // 记录scrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录scrollView初始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        [self scrollViewAddObservers]; // 如果newSuperview不为空，就注册成为观察者
        
    }
}

#pragma mark - KVO
// 注册成为观察者:ContentOffset、ContentSize、PanGestureRecognizer
- (void)scrollViewAddObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MTRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:MTRefreshKeyPathContentSize options:options context:nil];
    // ？？
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:MTRefreshKeyPathPanState options:options context:nil];

}

// 注销观察者
- (void)scrollViewRemoveObservers {
    [self.superview removeObserver:self forKeyPath:MTRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MTRefreshKeyPathContentSize];
    
    [self.pan removeObserver:self forKeyPath:MTRefreshKeyPathPanState];
    self.pan = nil; // 防止循环引用
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    // WHY？？？
    if (!self.userInteractionEnabled) return;
    
    // 不管是否隐藏，都要处理
    if ([keyPath isEqualToString:MTRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 隐藏时不作处理, WHY?
    if (self.hidden) return;
    if ([keyPath isEqualToString:MTRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:MTRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary <NSString *, id>*)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary <NSString *, id>*)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary <NSString *, id>*)change{}

@end
