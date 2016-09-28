//
//  RootViewController.m
//  ZhihuDaily
//
//  Created by zhaimengyang on 9/2/16.
//  Copyright © 2016 zhaimengyang. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
#import "HomeRootViewController.h"
#import "UIView+Extension.h"

@interface RootViewController () <UICollectionViewDelegateFlowLayout>

@end

static NSString *const RootViewControllerCellID = @"RootViewControllerCell";

@implementation RootViewController

#pragma mark - initializer

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.view.backgroundColor = [UIColor greenColor];
        
        self.collectionView.bounces = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled = YES;
        
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:RootViewControllerCellID];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scroll) name:HomeIconBarButtonItemDidClick object:nil];
    }
    
    return self;
}

#pragma mark - action methods

- (void)scroll {
    CGFloat x_offset = self.collectionView.contentOffset.x;
    
    [NSIndexPath indexPathForItem:0 inSection:0];
    
    if (x_offset) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    } else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

#pragma mark - view

- (void)viewWillAppear:(BOOL)animated {
    CGSize size = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [self.collectionView setContentOffset:CGPointMake(size.width, 0) animated:NO];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RootViewControllerCellID forIndexPath:indexPath];
    
    if (indexPath.item) {
        HomeViewController *homeVC = [HomeViewController homeViewController];
        [cell.contentView addSubview:homeVC.view];
    } else {
        cell.contentView.backgroundColor = [UIColor blueColor];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"This is a view to be programmed!";
        label.textColor = [UIColor greenColor];
        [label sizeToFit];
        [cell.contentView addSubview:label];
        label.y = label.superview.height * 0.5;
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    switch (indexPath.item) {
        case 0:
            size = CGSizeMake(0.75 * [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            break;
            
        case 1:
            size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            break;
            
        default:
            break;
    }
    
    return size;
}

@end
