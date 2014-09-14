//
//  SetUsernameViewController.h
//  braindu-coredata
//
//  Created by Steven Schofield on 14/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUsernameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)updateEmail:(id)sender;


@end
