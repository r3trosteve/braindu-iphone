//
//  HomeViewController.h
//  braindu-coredata
//
//  Created by Steven Schofield on 17/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchableContainerViewController.h"

@interface HomeViewController : UIViewController

@property (nonatomic, weak) SwitchableContainerViewController *switchableContainer;
@property (nonatomic, strong) NSArray *subviewIdentifiers;

@end
