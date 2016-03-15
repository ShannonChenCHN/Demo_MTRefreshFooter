//
//  MTCollectionViewController.m
//  Demo_MTRefreshFooter
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 Meitun. All rights reserved.
//

#import "MTCollectionViewController.h"
#import "UIViewController+MTExtension.h"
#import "MTSecondViewController.h"
#import "UIScrollView+MTRefresh.h"

@interface MTCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *colors;

@end

static NSString *const kMTCollectionViewCellID = @"kMTCollectionViewCellID";

@implementation MTCollectionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.colors = @[].mutableCopy;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 80);
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.minimumInteritemSpacing = 20;
        layout.minimumLineSpacing = 20;
        return [self initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
         [self performSelector:NSSelectorFromString(self.methodName) withObject:nil];
#pragma clang diagnostic pop
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kMTCollectionViewCellID];

}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 设置尾部控件的显示和隐藏
//    self.collectionView.mt_footer.hidden = self.colors.count == 0;
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMTCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MTSecondViewController *secondVC = [[MTSecondViewController alloc] init];
    if (indexPath.row % 2) {
        [self.navigationController pushViewController:secondVC animated:YES];
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:secondVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
