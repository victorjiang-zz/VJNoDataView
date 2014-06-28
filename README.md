VJNoDataView
============

no data view

# 背景

###### 问题:

  1.
  项目中我们经常会用网络请求数据来绘制页面
  而有时候网络请求较慢,甚至请求失败

  又因为我们几乎都是通过xib文件来拖控件到界面上
  这些控件都有其缺省值,比如"UILabel"控件的缺省值是"label"

  所以网络请求较慢,或者失败的情况下会看到控件的缺省值,界面不友好,不美观


  2.
  无网络的情况时,显示一个无网络的提示页面(相当于另一种NoDataView)
  此时页面上会有一个"重新加载"的按钮




###### 解决办法:

  在获取数据中,以及获取数据失败的情况下,界面显示一个没有数据的页面(NoDataView)
  比如用一张带LOGO的图片,像QQ空间
  获取数据成功后,移除该页面




###### 功能:

  NoDataView添加下拉刷新,重新加载
  这里下拉刷新用的是[SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)

# 接口

## UIViewController (VJNoDataView)

1. `setCustomNoDataView:noDataView`

```
/**
 *  设置自定义的NoDataView,
 *  add在scrollView上,首先通过该方法进行初始化
 *
 *  @param noDataView 无数据页面,可以是获取不到数据的情况;或者无网络时的提示页面
 */
- (void)setCustomNoDataView:(UIView *)noDataView;
```

2. `setPullToRefreshEnabled:enabled`

```
/**
 *  使能下拉刷新
 *
 *  @param enabled 是否使能,缺省使能下拉刷新
 */
 - (void)setPullToRefreshEnabled:(BOOL)enabled;
```

3. `setNoDataViewHidden:hidden`

```
/**
 *  隐藏/显示NoDataView
 *  这里实际操作的是scrollView
 *
 *  @param hidden 是否隐藏,否则显示
 */
- (void)setNoDataViewHidden:(BOOL)hidden;
```

4. `reloadData`

```
/**
 *  重新加载
 *  比如下拉刷新的时候会触发该方法,
 *  该方法必须在自定义类中重写
 */
- (void)reloadData;
```
