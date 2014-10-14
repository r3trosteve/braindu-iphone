//
//  SetUsernameViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 14/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <BrainduDataModel/BrainduDataModel.h>
#import "SetUsernameViewController.h"

@interface SetUsernameViewController ()

@end

@implementation SetUsernameViewController

@synthesize activityIndicator;

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
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
    
}


- (IBAction)updateEmail:(id)sender {
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([email length] == 0 ) {
        [self performSegueWithIdentifier:@"registerSuccessSegueIdentifier" sender:nil];
        
    }
    else {
        
        [activityIndicator startAnimating];
        
        BUPUser *user = [BUPUser currentUser];
        user.email = email;
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self performSegueWithIdentifier:@"registerSuccessSegueIdentifier" sender:nil];
            }
            [activityIndicator stopAnimating];
        }];
    }

}
@end

