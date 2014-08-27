//
//  BUItemViewController.h
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BUChart;
@class BUItem;

@interface BUItemViewController : UIViewController

@property (strong, nonatomic) BUChart *chart;
@property (strong, nonatomic) NSSet *items;
@property (strong, nonatomic) BUItem *item;

@end
