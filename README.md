VJNoDataView
============

no data view

# 背景

###### 问题:

1. 项目中我们经常会用网络请求数据来绘制页面，而有时候网络请求较慢,甚至请求失败。又因为我们几乎都是通过xib文件来拖控件到界面上，这些控件都有其缺省值，比如"UILabel"控件的缺省值是"label"。所以网络请求较慢,或者失败的情况下会看到控件的缺省值,界面不友好,不美观。

2. 无网络的情况时,显示一个无网络的提示页面，此时页面上会有一个"重新加载"的按钮

3. 数据为空时,显示一个无数据的提示页面

###### 解决办法:

在获取数据中,以及获取数据失败的情况下,界面显示一个没有数据的页面，比如用一张带LOGO的图片,像QQ空间，获取数据成功后,移除该页面。

###### 功能:

重新加载

# 接口

## UIViewController (VJNoDataView)

1. `VJNoDataType`

```
/**
 *  无数据类型
 */
typedef NS_ENUM(NSUInteger, VJNoDataType){
    /**
     *  正常，不显示无数据view
     */
    VJNoDataType_Normal,
    /**
     *  正在加载页
     */
    VJNoDataType_Loading,
    /**
     *  无数据页，获取数据为空
     */
    VJNoDataType_NoData,
    /**
     *  网络异常页
     */
    VJNoDataType_NetworkError
};
```

2. `vj_setNoDataEnable:enable`

```
/**
 *  是否使能NoDataView，缺省使能
 *
 *  @param enable 使能
 */
- (void)vj_setNoDataEnable:(BOOL)enable;
```

3. `vj_setNoDataType:noDataType`

```
/**
 *  设置当前类型
 *
 *  @param noDataType 类型
 */
- (void)vj_setNoDataType:(VJNoDataType)noDataType;
```

4. `vj_setNoDataView:noDataView forNoDataType:noDataType`

```
/**
 *  设置不同类型显示的view，有默认的view
 *
 *  @param noDataView view
 *  @param noDataType 类型
 */
- (void)vj_setNoDataView:(UIView *)noDataView forNoDataType:(VJNoDataType)noDataType;
```

5. `vj_reloadData`

```
/**
 *  重新加载
 */
- (void)vj_reloadData;
```