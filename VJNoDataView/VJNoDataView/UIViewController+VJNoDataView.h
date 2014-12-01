//
//  UIViewController+VJNoDataView.h
//  VJNoDataView
//
//  issue:
//
//  we often use storyboard or xib files to creat views,
//  many controls have their default value, et. UILabel's default text is "Label"
//
//  there are also many network requests in the app
//  sometimes the request is slow, when the request is loading, or the request is failed
//  these controls shown with default value, out of our expecting data, unfriendly!
//
//  there are three types need us to handle
//
//  1.
//  loading
//
//  2.
//  network error
//
//  3.
//  without any data
//
//
//
//
//  solution:
//
//  when the status is loading, or the result is without data, or network error,
//  we can use a simple view over all views to express the status
//  the view provide a function to reload data
//
//
//
//
//  Function:
//
//  reloadData
//
//  Created by Victor Jiang on 6/28/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  no data type
 */
typedef NS_ENUM(NSUInteger, VJNoDataType){
    /**
     *  normal
     */
    VJNoDataType_Normal,
    /**
     *  loading
     */
    VJNoDataType_Loading,
    /**
     *  without any data
     */
    VJNoDataType_NoData,
    /**
     *  Network Error
     */
    VJNoDataType_NetworkError
};

@interface UIViewController (VJNoDataView)

/**
 *  should enable this module
 *  default enable
 *
 *  @param enable
 */
- (void)vj_setNoDataEnable:(BOOL)enable;

/**
 *  set current type
 *  addSubView on self.view
 *
 *  @param noDataType type
 */
- (void)vj_setNoDataType:(VJNoDataType)noDataType;

/**
 *  set current type
 *
 *  @param noDataType type
 *  @param view       noDataView's superView
 */
- (void)vj_setNoDataType:(VJNoDataType)noDataType onView:(UIView *)view;

/**
 *  set custom view for different type
 *  with default view
 *
 *  @param noDataView custom view, when param is nil, use default view
 *  @param noDataType type
 */
- (void)vj_setNoDataView:(UIView *)noDataView forNoDataType:(VJNoDataType)noDataType;

/**
 *  reloadData
 */
- (void)vj_reloadData;

@end
