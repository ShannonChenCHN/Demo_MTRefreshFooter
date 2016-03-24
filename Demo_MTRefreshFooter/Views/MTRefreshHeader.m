//
//  MTRefreshHeader.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/24.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "MTRefreshHeader.h"
#import "UIScrollView+MTRefresh.h"

@implementation UILabel(MTRefresh)

+ (instancetype)label {
    UILabel *label = [[self alloc] init];
    label.font = MTRefreshLabelFont;
    label.textColor = MTRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end


@interface MTRefreshHeader()
@property (assign, nonatomic) CGFloat insetTDelta;


@property (strong, nonatomic) NSMutableDictionary <NSNumber *, NSString *>*stateTitles; ///< 所有状态对应的文字
@property (nonatomic, weak) UILabel *stateLabel;
@property (nonatomic, weak) UIImageView *gifView;

@property (strong, nonatomic) NSMutableDictionary <NSNumber *,NSArray <UIImage *>*>*stateImages; ///< 所有状态对应的动画图片
@property (strong, nonatomic) NSMutableDictionary <NSNumber *, NSNumber *>*stateDurations; ///< 所有状态对应的动画时间


@end

@implementation MTRefreshHeader

#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

- (UIImageView *)gifView {
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

#pragma mark - Class methods
+ (instancetype)headerWithRefreshingHandler:(MTRefreshActionHandler)handler {
    MTRefreshHeader *header = [[MTRefreshHeader alloc] init];
    header.refreshingBlock = handler;
    return header;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 设置高度
        self.mt_h = MTRefreshHeaderHeight;
        
        // 默认是普通状态
        self.state = MTRefreshStateIdle;
        
        // 初始化文字
        [self setTitle:MTRefreshHeaderIdleText forState:MTRefreshStateIdle];
        [self setTitle:MTRefreshHeaderPullingText forState:MTRefreshStatePulling];
        [self setTitle:MTRefreshHeaderRefreshingText forState:MTRefreshStateRefreshing];
        
        // 设置普通状态的动画图片
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=60; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
            [idleImages addObject:image];
        }
        [self setImages:idleImages forState:MTRefreshStateIdle];
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
            [refreshingImages addObject:image];
        }
        [self setImages:refreshingImages forState:MTRefreshStatePulling];
        
        // 设置正在刷新状态的动画图片
        [self setImages:refreshingImages forState:MTRefreshStateRefreshing];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.mt_y = - self.mt_h;
    
    if (self.stateLabel.hidden) return;
    self.stateLabel.frame = self.bounds;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mt_w = self.mt_w * 0.5 - 90;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.mt_w = newSuperview.mt_w;
        // 设置位置
        self.mt_x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        // 添加监听
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.state == MTRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = MTRefreshStateRefreshing;
    }
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MTRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:MTRefreshKeyPathContentSize options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:MTRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MTRefreshKeyPathContentSize];;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:MTRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:MTRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    // 在刷新的refreshing状态
    if (self.state == MTRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.mt_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mt_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mt_h + _scrollViewOriginalInset.top ? self.mt_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mt_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mt_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mt_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mt_h;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MTRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MTRefreshStatePulling;
        } else if (self.state == MTRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MTRefreshStateIdle;
        }
    } else if (self.state == MTRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self startRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }

}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{

}

#pragma mark - 公共方法
#pragma mark 进入刷新状态
- (void)startRefreshing
{
    [UIView animateWithDuration:MTRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = MTRefreshStateRefreshing;
    } else {
        // 预发当前正在刷新中时调用本方法使得header insert回置失败
        if (self.state != MTRefreshStateRefreshing) {
            self.state = MTRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}

#pragma mark 结束刷新状态
- (void)finishRefreshing
{
    if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           self.state = MTRefreshStateIdle;
        });
    } else {
        self.state = MTRefreshStateIdle;
    }
    
}

- (void)setTitle:(NSString *)title forState:(MTRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MTRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mt_h) {
        self.mt_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MTRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}


#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return self.state == MTRefreshStateRefreshing || self.state == MTRefreshStateWillRefresh;
}

#pragma mark 根据拖拽进度设置
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    
    if (self.isRefreshing) return;
    
    NSArray *images = self.stateImages[@(MTRefreshStateIdle)];
    if (self.state != MTRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
    NSLog(@"正在下拉");

}

#pragma mark - 内部方法
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    });
}

- (void)setState:(MTRefreshState)state {
    MTRefreshState oldState = self.state;
    if (state == oldState) return;
    _state = state;
    
    // 根据状态做事情
    if (state == MTRefreshStateIdle) {
        if (oldState != MTRefreshStateRefreshing) return;
        
        // 可以在这里保存刷新时间
        
        // 恢复inset和offset
        [UIView animateWithDuration:MTRefreshSlowAnimationDuration animations:^{
            self.scrollView.mt_insetT += self.insetTDelta;
            
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
        }];
    } else if (state == MTRefreshStateRefreshing) {
        [UIView animateWithDuration:MTRefreshFastAnimationDuration animations:^{
            // 增加滚动区域
            CGFloat top = self.scrollViewOriginalInset.top + self.mt_h;
            self.scrollView.mt_insetT = top;
            
            // 设置滚动位置
            self.scrollView.mt_offsetY = - top;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 根据状态做事情
    if (state == MTRefreshStatePulling || state == MTRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == MTRefreshStateIdle) {
        [self.gifView stopAnimating];
    }

}


@end
