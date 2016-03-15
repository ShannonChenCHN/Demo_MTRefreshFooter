//
//  MTSecondViewController.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "MTSecondViewController.h"

@interface MTSecondViewController ()

@end

@implementation MTSecondViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试控制器";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
}

- (void)close {
    if (self.presentingViewController) { // if presented
        [self dismissViewControllerAnimated:YES completion:nil];
    } else { // if pushed
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
