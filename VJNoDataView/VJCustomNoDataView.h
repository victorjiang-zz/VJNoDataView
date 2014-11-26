//
//  VJCustomNoDataView.h
//  VJNoDataView
//
//  Created by victorjiang on 11/26/14.
//  Copyright (c) 2014 Victor Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VJCustomNoDataView : UIView

@property (nonatomic, copy) void (^refreshBlock)();

@end
