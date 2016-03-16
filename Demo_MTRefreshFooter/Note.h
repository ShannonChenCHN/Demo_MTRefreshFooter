//
//  Note.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/16.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#ifndef Note_h
#define Note_h

- [MJTableViewController example12]


self.tableView.mj_footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
1. + [MJRefreshFooter footerWithRefreshingTarget: refreshingAction: ] // 创建footer对象

 1.1. MJRefreshFooter *cmp = [[self alloc] init]; // 初始化MJRefreshFooter
     -[MJRefreshComponent initWithFrame:]

    1.1.1. [self prepare];                  // 准备工作
           -[MJChiBaoZiFooter prepare] // 设置图片
           -[MJRefreshAutoStateFooter prepare] // 初始化文字，添加点击手势
           -[MJRefreshAutoFooter prepare] // 默认允许自动刷新，且底部控件100%出现时才会自动刷新
           -[MJRefreshFooter prepare] // footer默认高度，不自动隐藏

        1.1.1.1  [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
                -[MJRefreshAutoGifFooter setImages: forState:]
                -[MJRefreshAutoGifFooter setImages: duration: forState:] // 保存指定状态对应的gif图片数组和时长，并根据图片设置控件的高度

     1.1.2. self.state = MJRefreshStateIdle;
            -[MJRefreshAutoGifFooter setState:]   // 调整图片显示
            -[MJRefreshAutoStateFooter setState:] // 调整文字显示
            -[MJRefreshAutoFooter setState:] // 如果是正在刷新，延时5秒回调

 1.2. [cmp setRefreshingTarget:target refreshingAction:action];
     -[MJRefreshComponent setRefreshingTarget: refreshingAction:]

2. - [UIScrollView (MJRefresh) setMj_footer:]

3. - [MJRefreshAutoFooter willMoveToSuperview:] // 调整scrollView的contentInset
   - [MJRefreshFooter willMoveToSuperview:] // 监听scrollView数据的变化，reloadData时根据数量决定是否自动隐藏
   - [MJRefreshComponent willMoveToSuperview:] // 注册/注销KVO，监听scrollView，记录UIScrollView和UIScrollView最开始的contentInset

4. - [MJRefreshComponent layoutSubviews]

   - [MJRefreshAutoGifFooter placeSubviews]  // 设置图片的位置
   - [MJRefreshAutoStateFooter placeSubviews] // 设置stateLabel的位置
   - [MJRefreshComponent placeSubviews] // do nothing

5. - [MJRefreshComponent drawRect:] // 预防view还没显示出来就调用了beginRefreshing

6. - [MJRefreshAutoFooter scrollViewPanStateDidChange:] // 开始刷新

7. - [MJRefreshAutoFooter scrollViewContentOffsetDidChange:] // 开始刷新

8. - [MJRefreshAutoFooter scrollViewContentSizeDidChange:]  // 调整y值

#endif /* Note_h */
