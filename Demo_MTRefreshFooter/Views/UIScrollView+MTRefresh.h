//
//  UIScrollView+MTRefresh.h
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTRefreshFooter.h"

@interface UIScrollView (MTRefresh)

@property (nonatomic, strong) MTRefreshFooter *mt_footer; ///< accessory view below content, which is used to showing the loading state when pull up. default is nil.

@end
