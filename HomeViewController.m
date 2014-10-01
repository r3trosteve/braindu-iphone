//
//  HomeViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 17/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "HomeViewController.h"
#import "BUPUser.h"
#import "BUPChart.h"
#import "ProfileViewController.h"

@interface HomeViewController ()



@end

@implementation HomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.subviewIdentifiers = @[@"MyCharts", @"AllCharts"];
    [self.switchableContainer loadViewControllerWithIdentifier:self.subviewIdentifiers.firstObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    [self.switchableContainer loadViewControllerWithIdentifier:self.subviewIdentifiers[control.selectedSegmentIndex]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"EmbedSwitchable"]) {
        self.switchableContainer = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"showCurrentUserProfile"]) {
        ProfileViewController *profileViewController = (ProfileViewController *)segue.destinationViewController;
        profileViewController.user = [BUPUser currentUser];
    }
}



@end
