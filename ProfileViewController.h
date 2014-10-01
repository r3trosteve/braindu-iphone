//
//  ProfileViewController.h
//  braindu-coredata
//
//  Created by Steven Schofield on 28/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APAvatarImageView.h"
#import <Parse/Parse.h>

@class BUPUser;
@class BUPChart;

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet APAvatarImageView *userAvatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *userBannerImage;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTotalChartsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTotalItemsCountLabel;

@property (strong, nonatomic) BUPUser *user;
@property (strong, nonatomic) IBOutlet UITableView *userChartTable;

@end
