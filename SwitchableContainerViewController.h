//
//  SwitchableContainerViewController.h
//  braindu-coredata
//
//  Created by Steven Schofield on 17/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchableContainerViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *subviewController;

- (void)loadViewControllerWithIdentifier:(NSString *)identifier;

@end
