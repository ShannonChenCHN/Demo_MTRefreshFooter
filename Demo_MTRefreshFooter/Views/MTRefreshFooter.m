//
//  MTRefreshFooter.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/16.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "MTRefreshFooter.h"
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

//____________________________________________________________________________________________________________________

@interface MTRefreshFooter ()

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (strong, nonatomic) NSMutableDictionary <NSNumber *, NSString *>*stateTitles; ///< 所有状态对应的文字
@property (nonatomic, weak) UILabel *stateLabel;
@property (nonatomic, weak) UIImageView *gifView;;

@property (strong, nonatomic) NSMutableDictionary <NSNumber *,NSArray <UIImage *>*>*stateImages; ///< 所有状态对应的动画图片
@property (strong, nonatomic) NSMutableDictionary <NSNumber *, NSNumber *>*stateDurations; ///< 所有状态对应的动画时间

@end

@implementation MTRefreshFooter

#pragma mark - lazy initialization
- (NSMutableDictionary *)stateTitles {
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel {
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

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}


#pragma mark - Class methods
+ (instancetype)footerWithRefreshingHandler:(MTRefreshActionHandler)handler {
    MTRefreshFooter *footer = [[MTRefreshFooter alloc] init];
    footer.refreshHandler = handler;
    return footer;
}

#pragma mark - overrided methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        self.mt_y = MTRefreshFooterHeight; // 设置默认高度
        self.state = MTRefreshStateIdle; // 默认初始状态
        
        // 初始化文字
        [self setTitle:MTRefreshAutoFooterIdleText forState:MTRefreshStateIdle];
        [self setTitle:MTRefreshAutoFooterRefreshingText forState:MTRefreshStateRefreshing];
        [self setTitle:MTRefreshAutoFooterNoMoreDataText forState:MTRefreshStateNoMoreData];
        
        // 设置正在刷新状态的动画图片
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
            [refreshingImages addObject:image];
        }
        [self setImages:refreshingImages forState:MTRefreshStateRefreshing];
    }
    return self;
}

// 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
    

    // 动图
    if (self.gifView.constraints.count) return;
    self.gifView.frame = self.bounds;
    self.gifView.contentMode = UIViewContentModeRight;
    self.gifView.mt_w = self.mt_w * 0.5 - 90;
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
#warning WHY???
    // 预防view还没显示出来就调用了beginRefreshing
    if (self.state == MTRefreshStateWillRefresh) {
        self.state = MTRefreshStateRefreshing;
    }
}

/* When a view is removed from a superview, the system sends willMoveToSuperview: to the view. The parameter is nil.
 * http://stackoverflow.com/questions/25996906/willmovetosuperview-is-called-twice
 */
// 当superview发生改变时调用该方法
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return; // 如果不是添加到scrollView上而是其他view，就不做任何处理
    
    [self scrollViewRemoveObservers]; // 不管newSuperview是不是nil，都要先注销观察者
    
    if (newSuperview) { // 如果被添加到scrollView上
        self.mt_w = newSuperview.mt_w; // 宽度
        self.mt_x = 0;  // 原点x
        
        // 记录scrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录scrollView初始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        // 永远支持垂直方向的弹簧效果，确保一直能够上拉
        _scrollView.alwaysBounceVertical = YES;
        
        [self scrollViewAddObservers]; // 如果newSuperview不为空，就注册成为观察者
    }
    
    // 调整位置
    [self layoutWithNewSuperview:newSuperview];
}

- (void)layoutWithNewSuperview:(UIView *)newSuperview  {
    if (newSuperview) { // 被添加到新父控件上
        if (self.hidden == NO) {
            self.scrollView.mt_insetB += self.mt_h; // 调整scrollView的contentInset
        }
        self.mt_y = self.scrollView.mt_contentH; // 设置y位置
    } else {            // 被移除了
        if (self.hidden == NO) {
            self.scrollView.mt_insetB -= self.mt_h; // 还原scrollView的contentInset
        }
    }
}

#pragma mark - KVO ，监听scrollView的contentSize、contentOffset和pan手势state的变化
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
    
#warning WHY???
    if (!self.userInteractionEnabled) return; // 遇到这些情况就直接返回
    
    // 不管是否隐藏，都要处理
    if ([keyPath isEqualToString:MTRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    // 隐藏时不作处理
#warning WHY???
    if (self.hidden) return;
    if ([keyPath isEqualToString:MTRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:MTRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary <NSString *, id>*)change{
    // contentSize 变化时，调整footer位置
    self.mt_y = self.scrollView.mt_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary <NSString *, id>*)change{
    if (self.state != MTRefreshStateIdle || self.mt_y == 0) return; //
    
    if (_scrollView.mt_insetT + _scrollView.mt_contentH > _scrollView.mt_h) { // 内容超过一个屏幕
        // 这里的_scrollView.mt_contentH替换掉self.mt_y更为合理
        if (_scrollView.mt_offsetY >= _scrollView.mt_contentH - _scrollView.mt_h + _scrollView.mt_insetB - self.mt_h/* + self.mt_h * self.triggerAutomaticallyRefreshPercent*/) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self startRefreshing];
        }
    }
}


- (void)scrollViewPanStateDidChange:(NSDictionary <NSString *, id>*)change{
    if (self.state != MTRefreshStateIdle) return; // 如果还未加载过，才继续响应
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.mt_insetT + _scrollView.mt_contentH <= _scrollView.mt_h) {  // 整个scrollView展示的内容还不够一个屏幕
            if (_scrollView.mt_offsetY >= - _scrollView.mt_insetT) { // 向上拽
                [self startRefreshing];
            }
        } else {                // 整个scrollView展示的内容超出一个屏幕，需要往上滚才能完全查看
            if (_scrollView.mt_offsetY >= _scrollView.mt_contentH + _scrollView.mt_insetB - _scrollView.mt_h) {
                [self startRefreshing];
            }
        }
    }
}

#pragma mark - public methods
- (void)setTitle:(NSString *)title forState:(MTRefreshState)state {
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark 开始加载更多
- (void)startRefreshing {
    [UIView animateWithDuration:MTRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];

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
- (void)finishRefreshing {
    self.state = MTRefreshStateIdle;
}

- (void)finishRefreshingWithNoMoreData {
    self.state = MTRefreshStateNoMoreData;
}

#pragma mark - 内部方法
#pragma mark 是否正在刷新
- (BOOL)isRefreshing {
    return self.state == MTRefreshStateRefreshing || self.state == MTRefreshStateWillRefresh;
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MTRefreshState)state {
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;            // 保存指定状态对应的gif图片数组
    self.stateDurations[@(state)] = @(duration);    // 保存指定状态对应的时长
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mt_h) {
        self.mt_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MTRefreshState)state {
    [self setImages:images duration:images.count * 0.1 forState:state];
}

- (void)setState:(MTRefreshState)state {
    
    MTRefreshState oldState = self.state;
    if (state == oldState) return;
    _state = state;
    
    if (state == MTRefreshStateRefreshing) {
        // 刷新事件回调
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    }
    // 设置对应文案
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 根据状态做事情
    if (state == MTRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        [self.gifView stopAnimating]; // 取消原有的动画
        
        self.gifView.hidden = NO;
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == MTRefreshStateNoMoreData || state == MTRefreshStateIdle) {
        [self.gifView stopAnimating];
        self.gifView.hidden = YES;
    }
}

- (void)executeRefreshingCallback {
    // 回到主队列回调
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshHandler) {
            self.refreshHandler();
        }
    });
}

@end

