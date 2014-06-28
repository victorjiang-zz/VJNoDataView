//
//  UIViewController+VJNoDataView.m
//  VJNoDataView
//
//  Created by Victor Jiang on 6/28/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import "UIViewController+VJNoDataView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import <objc/runtime.h>

static void *baseScrollViewKey;
static void *noDataViewKey;

@interface UIViewController (VJNoDataViewPrivate)

/**
 *  最底层的scrollView
 */
@property (nonatomic, strong) UIScrollView *baseScrollView;

/**
 *  NoDataView
 */
@property (nonatomic, strong) UIView *noDataView;

@end

@implementation UIViewController (VJNoDataViewPrivate)

- (UIScrollView *)baseScrollView
{
    return objc_getAssociatedObject(self, &baseScrollViewKey);
}

- (void)setBaseScrollView:(UIScrollView *)baseScrollView
{
    objc_setAssociatedObject(self, &baseScrollViewKey, baseScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)noDataView
{
    return objc_getAssociatedObject(self, &noDataViewKey);
}

- (void)setNoDataView:(UIView *)noDataView
{
    objc_setAssociatedObject(self, &noDataViewKey, noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (VJNoDataView)


- (void)setCustomNoDataView:(UIView *)noDataView
{
    if (!self.baseScrollView) {
        //初始化baseScrollView
        self.baseScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.baseScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.baseScrollView.frame), CGRectGetHeight(self.baseScrollView.frame)+1);
        [self.baseScrollView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.baseScrollView];
        
        //添加下拉刷新
        __weak typeof(self)weakSelf = self;
        [self.baseScrollView addPullToRefreshWithActionHandler:^{
            [weakSelf reloadData];
        }];
    }
    
    //移除原来的NoDataView
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    
    //add新的NoDataView
    if (noDataView) {
        self.noDataView = noDataView;
        [self.baseScrollView addSubview:self.noDataView];
    }
    
//    [self setNoDataViewHidden:NO];
}

- (void)setPullToRefreshEnabled:(BOOL)enabled
{
    self.baseScrollView.showsPullToRefresh = enabled;
}

- (void)setNoDataViewHidden:(BOOL)hidden
{
    //先恢复下拉刷新,scrollView弹回时间0.2s
    [self.baseScrollView.pullToRefreshView stopAnimating];
    
    if (hidden) {
        //延迟0.2s隐藏
        [self performSelector:@selector(hideBaseScrollView) withObject:nil afterDelay:0.2f];
    } else {
        //显示在最上层
        [self.view bringSubviewToFront:self.baseScrollView];
        self.baseScrollView.hidden = NO;
    }
}

- (void)hideBaseScrollView
{
    self.baseScrollView.hidden = YES;
}

- (void)reloadData
{
    //TODO: 在自定义类中实现
}

@end
