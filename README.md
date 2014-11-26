VJNoDataView
============

no data view

# Background

###### Issue:

We often use storyboard or xib files to creat views, and many controls have their default value, et. UILabel's default text is "Label".

There are also many network requests in app, sometimes the request is slow. When the request is loading, or the request is failed, these controls shown with default value, not our expect data. unfriendly!

There are three types need us to handle:

1. Loading

2. Network Error

3. Without any data

###### Solution:

When the status is loading, or the result is without data, or network error, we can use a simple view over all views to express the status. The view provide a function to reload data.

###### Function:

reloadData

# API

## UIViewController (VJNoDataView)

1.`VJNoDataType`

```
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
```

2.`vj_setNoDataEnable:enable`

```
/**
 *  should enable this module
 *  default enable
 *
 *  @param enable
 */
- (void)vj_setNoDataEnable:(BOOL)enable;
```

3.`vj_setNoDataType:noDataType`

```
/**
 *  set current type
 *
 *  @param noDataType type
 */
- (void)vj_setNoDataType:(VJNoDataType)noDataType;
```

4.`vj_setNoDataView:noDataView forNoDataType:noDataType`

```
/**
 *  set custom view for different type
 *  with default view
 *
 *  @param noDataView custom view, when param is nil, use default view
 *  @param noDataType type
 */
- (void)vj_setNoDataView:(UIView *)noDataView forNoDataType:(VJNoDataType)noDataType;
```

5.`vj_reloadData`

```
/**
 *  reloadData
 */
- (void)vj_reloadData;
```