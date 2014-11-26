//
//  VJViewController.m
//  VJNoDataView
//
//  Created by Victor Jiang on 6/28/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import "VJViewController.h"
#import "VJCustomNoDataView.h"

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
    
    __weak typeof(self) weakSelf = self;
    VJCustomNoDataView *view = [[[NSBundle mainBundle] loadNibNamed:@"VJCustomNoDataView" owner:nil options:nil] objectAtIndex:0];
    view.refreshBlock = ^void(){
        [weakSelf vj_reloadData];
    };
    [self vj_setNoDataView:view forNoDataType:VJNoDataType_NetworkError];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    UITableViewController
}

- (IBAction)loadingButtonPressed:(id)sender {
    //no data
    [self vj_setNoDataType:VJNoDataType_Loading];
    
    [self performSelector:@selector(backToNormal) withObject:nil afterDelay:3];
}

- (void)backToNormal
{
    [self vj_setNoDataType:VJNoDataType_Normal];
}

- (IBAction)noDataButtonPressed:(id)sender {
    //pull
    [self vj_setNoDataType:VJNoDataType_NoData];
}

- (IBAction)networkErrorPressed:(id)sender {
    //button
    [self vj_setNoDataType:VJNoDataType_NetworkError];
}

- (void)vj_reloadData
{
    NSLog(@"reload data at %s", __PRETTY_FUNCTION__);
    [self loadingButtonPressed:nil];
}

@end
