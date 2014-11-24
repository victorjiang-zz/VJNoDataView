//
//  UIViewController+VJNoDataView.m
//  VJNoDataView
//
//  Created by Victor Jiang on 6/28/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import "UIViewController+VJNoDataView.h"
#import <objc/runtime.h>

static void *vj_noDataEnableKey;
static void *vj_loadingViewKey;
static void *vj_noDataViewKey;
static void *vj_networkErrorViewKey;

@interface UIViewController (VJNoDataViewPrivate)

@property (nonatomic, assign) BOOL vj_noDataEnable;

@property (nonatomic, strong) UIView *vj_loadingView;
@property (nonatomic, strong) UIView *vj_noDataView;
@property (nonatomic, strong) UIView *vj_networkErrorView;

@end

@implementation UIViewController (VJNoDataViewPrivate)

- (BOOL)vj_noDataEnable
{
    return objc_getAssociatedObject(self, &vj_noDataEnableKey);
}

- (void)setVj_noDataEnable:(BOOL)vj_noDataEnable
{
    objc_setAssociatedObject(self, &vj_noDataEnableKey, @(vj_noDataEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)vj_loadingView
{
    return objc_getAssociatedObject(self, &vj_loadingViewKey);
}

- (void)setVj_loadingView:(UIView *)vj_loadingView
{
    objc_setAssociatedObject(self, &vj_loadingViewKey, vj_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)vj_noDataView
{
    return objc_getAssociatedObject(self, &vj_noDataViewKey);
}

- (void)setVj_noDataView:(UIView *)vj_noDataView
{
    objc_setAssociatedObject(self, &vj_noDataViewKey, vj_noDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)vj_networkErrorView
{
    return objc_getAssociatedObject(self, &vj_networkErrorViewKey);
}

- (void)setVj_networkErrorView:(UIView *)vj_networkErrorView
{
    objc_setAssociatedObject(self, &vj_networkErrorViewKey, vj_networkErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (VJNoDataView)

- (void)vj_noDataViewDidLoad
{
    self.vj_noDataEnable = YES;
    
    [self makeLoadingView];
    [self makeNoDataView];
    [self makeNetworkErrorView];
    
    [self vj_noDataViewDidLoad];
}

+ (void)load
{
    SEL originalSelector = NSSelectorFromString(@"viewDidLoad");;
    SEL overrideSelector = @selector(vj_noDataViewDidLoad);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

#pragma mark - set method
- (void)vj_setNoDataEnable:(BOOL)enable
{
    self.vj_noDataEnable = enable;
    if (!enable) {
        self.vj_loadingView.hidden = YES;
        self.vj_noDataView.hidden = YES;
        self.vj_networkErrorView.hidden = YES;
    }
}

- (void)vj_setNoDataType:(VJNoDataType)noDataType
{
    //如果未使能，则都按正常显示
    if (!self.vj_noDataEnable) {
        noDataType = VJNoDataType_Normal;
    }
    
    switch (noDataType) {
        case VJNoDataType_Normal:
        {
            self.vj_loadingView.hidden = YES;
            self.vj_noDataView.hidden = YES;
            self.vj_networkErrorView.hidden = YES;
        }
            break;
        case VJNoDataType_Loading:
        {
            self.vj_loadingView.hidden = NO;
            self.vj_noDataView.hidden = YES;
            self.vj_networkErrorView.hidden = YES;
            [self.view bringSubviewToFront:self.vj_loadingView];
        }
            break;
        case VJNoDataType_NoData:
        {
            self.vj_loadingView.hidden = YES;
            self.vj_noDataView.hidden = NO;
            self.vj_networkErrorView.hidden = YES;
            [self.view bringSubviewToFront:self.vj_loadingView];
        }
            break;
        case VJNoDataType_NetworkError:
        {
            self.vj_loadingView.hidden = YES;
            self.vj_noDataView.hidden = YES;
            self.vj_networkErrorView.hidden = NO;
            [self.view bringSubviewToFront:self.vj_loadingView];
        }
            break;
            
        default:
            break;
    }
}

- (void)vj_setNoDataView:(UIView *)noDataView forNoDataType:(VJNoDataType)noDataType
{
    switch (noDataType) {
        case VJNoDataType_Normal:
            
            break;
        case VJNoDataType_Loading:
            self.vj_loadingView = noDataView;
            break;
        case VJNoDataType_NoData:
            self.vj_noDataView = noDataView;
            break;
        case VJNoDataType_NetworkError:
            self.vj_networkErrorView = noDataView;
            break;
            
        default:
            break;
    }
}

#pragma mark - make UI
- (void)makeLoadingView
{
    UIView *loadingView = [[UIView alloc] init];
    [loadingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:loadingView];
    loadingView.hidden = YES;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    UILabel *loadingLabel = [[UILabel alloc] init];
    loadingLabel.text = NSLocalizedString(@"Loading...", nil);
    loadingLabel.font = [UIFont systemFontOfSize:15.0f];
    loadingLabel.textColor = [UIColor darkGrayColor];
    [loadingView addSubview:loadingLabel];
    
    UIView *helperView = [[UIView alloc] init];
    [loadingView addSubview:helperView];
    
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    helperView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *loadingViewTop = [NSLayoutConstraint constraintWithItem:loadingView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0];
    NSLayoutConstraint *loadingViewLeading = [NSLayoutConstraint constraintWithItem:loadingView
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];
    NSLayoutConstraint *loadingViewBottom = [NSLayoutConstraint constraintWithItem:loadingView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0];
    NSLayoutConstraint *loadingViewTrailing = [NSLayoutConstraint constraintWithItem:loadingView
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1
                                                                            constant:0];
    [self.view addConstraints:@[loadingViewTop, loadingViewLeading, loadingViewBottom, loadingViewTrailing]];
    
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[activityIndicatorView]-5-[loadingLabel]-(>=0)-|" options:0 metrics:nil views:@{@"activityIndicatorView":activityIndicatorView, @"loadingLabel":loadingLabel}];
    NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:helperView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:activityIndicatorView
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1
                                                                   constant:0];
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:helperView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:loadingLabel
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1
                                                                        constant:0];
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:helperView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:loadingView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1 constant:0];
    NSLayoutConstraint *constraintCenterY1 = [NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:loadingView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1 constant:0];
    NSLayoutConstraint *constraintCenterY2 = [NSLayoutConstraint constraintWithItem:loadingLabel
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:loadingView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1 constant:0];
    
    [loadingView addConstraints:constraintH];
    [loadingView addConstraint:constraintCenterY1];
    [loadingView addConstraint:constraintCenterY2];
    [loadingView addConstraint:constraintLeft];
    [loadingView addConstraint:constraintRight];
    [loadingView addConstraint:constraintCenterX];
    
    self.vj_loadingView = loadingView;
}

- (void)makeNoDataView
{
    UIView *noDataView = [[UIView alloc] init];
    [noDataView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:noDataView];
    noDataView.hidden = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    UIColor *textColor = [UIColor darkGrayColor];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    noDataLabel.text = NSLocalizedString(@"NO Data", nil);
    noDataLabel.font = font;
    noDataLabel.textColor = textColor;
    [noDataView addSubview:noDataLabel];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [refreshButton setTitle:NSLocalizedString(@"Tap & Reload", nil) forState:UIControlStateNormal];
//    [refreshButton setTitleColor:textColor forState:UIControlStateNormal];
    refreshButton.titleLabel.font = font;
    [refreshButton addTarget:self action:@selector(vj_reloadData) forControlEvents:UIControlEventTouchUpInside];
    [noDataView addSubview:refreshButton];
    
    UIView *helperView = [[UIView alloc] init];
    [noDataView addSubview:helperView];
    
    noDataView.translatesAutoresizingMaskIntoConstraints = NO;
    noDataLabel.translatesAutoresizingMaskIntoConstraints = NO;
    refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
    helperView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *noDataViewTop = [NSLayoutConstraint constraintWithItem:noDataView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0];
    NSLayoutConstraint *noDataViewLeading = [NSLayoutConstraint constraintWithItem:noDataView
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];
    NSLayoutConstraint *noDataViewBottom = [NSLayoutConstraint constraintWithItem:noDataView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0];
    NSLayoutConstraint *noDataViewTrailing = [NSLayoutConstraint constraintWithItem:noDataView
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1
                                                                            constant:0];
    [self.view addConstraints:@[noDataViewTop, noDataViewLeading, noDataViewBottom, noDataViewTrailing]];
    
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[noDataLabel]-5-[refreshButton]-(>=0)-|" options:0 metrics:nil views:@{@"noDataLabel":noDataLabel, @"refreshButton":refreshButton}];
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:helperView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:noDataLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0];
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:helperView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:refreshButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:helperView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:noDataView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1 constant:0];
    NSLayoutConstraint *constraintCenterX1 = [NSLayoutConstraint constraintWithItem:noDataLabel
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:noDataView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1 constant:0];
    NSLayoutConstraint *constraintCenterX2 = [NSLayoutConstraint constraintWithItem:refreshButton
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:noDataView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1 constant:0];
    
    [noDataView addConstraints:constraintH];
    [noDataView addConstraint:constraintCenterX1];
    [noDataView addConstraint:constraintCenterX2];
    [noDataView addConstraint:constraintTop];
    [noDataView addConstraint:constraintBottom];
    [noDataView addConstraint:constraintCenterY];
    
    self.vj_noDataView = noDataView;
}

- (void)makeNetworkErrorView
{
    UIView *networkErrorView = [[UIView alloc] init];
    [networkErrorView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:networkErrorView];
    networkErrorView.hidden = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    UIColor *textColor = [UIColor darkGrayColor];
    
    UILabel *networkErrorLabel = [[UILabel alloc] init];
    networkErrorLabel.text = NSLocalizedString(@"Network Error", nil);
    networkErrorLabel.font = font;
    networkErrorLabel.textColor = textColor;
    [networkErrorView addSubview:networkErrorLabel];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [refreshButton setTitle:NSLocalizedString(@"Tap & Reload", nil) forState:UIControlStateNormal];
//    [refreshButton setTitleColor:textColor forState:UIControlStateNormal];
    refreshButton.titleLabel.font = font;
    [refreshButton addTarget:self action:@selector(vj_reloadData) forControlEvents:UIControlEventTouchUpInside];
    [networkErrorView addSubview:refreshButton];
    
    UIView *helperView = [[UIView alloc] init];
    [networkErrorView addSubview:helperView];
    
    networkErrorView.translatesAutoresizingMaskIntoConstraints = NO;
    networkErrorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
    helperView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *networkErrorViewTop = [NSLayoutConstraint constraintWithItem:networkErrorView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1
                                                                       constant:0];
    NSLayoutConstraint *networkErrorViewLeading = [NSLayoutConstraint constraintWithItem:networkErrorView
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];
    NSLayoutConstraint *networkErrorViewBottom = [NSLayoutConstraint constraintWithItem:networkErrorView
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1
                                                                          constant:0];
    NSLayoutConstraint *networkErrorViewTrailing = [NSLayoutConstraint constraintWithItem:networkErrorView
                                                                           attribute:NSLayoutAttributeTrailing
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1
                                                                            constant:0];
    [self.view addConstraints:@[networkErrorViewTop, networkErrorViewLeading, networkErrorViewBottom, networkErrorViewTrailing]];
    
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[networkErrorLabel]-5-[refreshButton]-(>=0)-|" options:0 metrics:nil views:@{@"networkErrorLabel":networkErrorLabel, @"refreshButton":refreshButton}];
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:helperView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:networkErrorLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:helperView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:refreshButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:helperView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:networkErrorView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1 constant:0];
    NSLayoutConstraint *constraintCenterX1 = [NSLayoutConstraint constraintWithItem:networkErrorLabel
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:networkErrorView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1 constant:0];
    NSLayoutConstraint *constraintCenterX2 = [NSLayoutConstraint constraintWithItem:refreshButton
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:networkErrorView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1 constant:0];
    
    [networkErrorView addConstraints:constraintH];
    [networkErrorView addConstraint:constraintCenterX1];
    [networkErrorView addConstraint:constraintCenterX2];
    [networkErrorView addConstraint:constraintTop];
    [networkErrorView addConstraint:constraintBottom];
    [networkErrorView addConstraint:constraintCenterY];
    
    self.vj_networkErrorView = networkErrorView;
}

- (void)vj_reloadData
{
    
}

@end
