//
//  SwitchableContainerViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 17/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "SwitchableContainerViewController.h"

@interface SwitchableContainerViewController ()

@property (nonatomic, strong) UIViewController *subviewController;

@end

@implementation SwitchableContainerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)loadViewControllerWithIdentifier:(NSString *)identifier
{
    [self.subviewController.view removeFromSuperview];
    [self.subviewController removeFromParentViewController];
    
    self.subviewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    CGRect frame = self.view.bounds;
    self.subviewController.view.frame = frame;
    
    [self.view addSubview:self.subviewController.view];
    [self addChildViewController:self.subviewController];
}

@end
