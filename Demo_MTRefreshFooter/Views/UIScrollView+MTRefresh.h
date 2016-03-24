//
//  UIScrollView+MTRefresh.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "MTRefreshFooter.h"
#import "MTRefreshHeader.h"

@interface UIScrollView (MTExtension)

@property (assign, nonatomic) CGFloat mt_insetT;
@property (assign, nonatomic) CGFloat mt_insetB;
@property (assign, nonatomic) CGFloat mt_insetL;
@property (assign, nonatomic) CGFloat mt_insetR;

@property (assign, nonatomic) CGFloat mt_offsetX;
@property (assign, nonatomic) CGFloat mt_offsetY;

@property (assign, nonatomic) CGFloat mt_contentW;
@property (assign, nonatomic) CGFloat mt_contentH;

@end


//___________________________________________________________________________________________________

@interface UIScrollView (MTRefresh)

@property (nonatomic, strong) MTRefreshHeader *mt_header;

@property (nonatomic, strong) MTRefreshFooter *mt_footer; ///< accessory view below content, which is used to showing the loading state when pull up. default is nil.

@end
