//
//  VJViewController.m
//  VJNoDataView
//
//  Created by Victor Jiang on 6/28/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import "VJViewController.h"

@interface VJViewController ()

@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) UIView *noNetPullView;
@property (nonatomic, strong) UIView *noNetButtonView;

@end

@implementation VJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //初始化自定义view
    //1.noDataView
    self.noDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 393)];
    noDataImageView.image = [UIImage imageNamed:@"nodata"];
    [self.noDataView addSubview:noDataImageView];
    self.noDataView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    
    //2.noNetPullView
    self.noNetPullView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *noNetPullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 349)];
    noNetPullImageView.image = [UIImage imageNamed:@"nonet_pull"];
    [self.noNetPullView addSubview:noNetPullImageView];
    self.noNetPullView.backgroundColor = [UIColor colorWithRed:252/255.0 green:249/255.0 blue:243/255.0 alpha:1];
    
    //3.noNetButtonView
    self.noNetButtonView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *noNetButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 348)];
    noNetButtonImageView.image = [UIImage imageNamed:@"nonet_btn"];
    [self.noNetButtonView addSubview:noNetButtonImageView];
    self.noNetButtonView.backgroundColor = [UIColor colorWithRed:227/255.0 green:230/255.0 blue:235/255.0 alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(96, 266, 116, 32);
    button.backgroundColor = [UIColor clearColor];
    [self.noNetButtonView addSubview:button];
    
    //设置NoDataView
    [self setCustomNoDataView:self.noDataView];
    [self setPullToRefreshEnabled:NO];
    
    //获取数据
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    UITableViewController
}

- (void)reloadData
{
    NSLog(@"reload data at %s", __PRETTY_FUNCTION__);
    
    [self performSelector:@selector(setNoDataViewHide:) withObject:[NSNumber numberWithBool:YES] afterDelay:2.0f];
}

- (void)setNoDataViewHide:(NSNumber *)hide
{
    [self setNoDataViewHidden:[hide boolValue]];
}


- (IBAction)noDataButtonPressed:(id)sender {
    //no data
    [self setCustomNoDataView:self.noDataView];
    [self setNoDataViewHidden:NO];
    [self setPullToRefreshEnabled:YES];
}


- (IBAction)noNetButtonPressed:(id)sender {
    //pull
    [self setCustomNoDataView:self.noNetPullView];
    [self setNoDataViewHidden:NO];
    [self setPullToRefreshEnabled:YES];
}

- (IBAction)noNetBtnPressed:(id)sender {
    //button
    [self setCustomNoDataView:self.noNetButtonView];
    [self setNoDataViewHidden:NO];
    [self setPullToRefreshEnabled:NO];
}

@end
