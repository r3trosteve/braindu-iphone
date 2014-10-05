//
//  itemReadViewController.h
//  braindu-coredata
//
//  Created by Steven Schofield on 04/10/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BUPChart;
@class BUPItem;
@class BUPUser;
@class BUPItemComment;

@interface ItemReadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) BUPItem *item;
@property (strong, nonatomic) BUPChart *chart;
@property (strong, nonatomic) NSSet *items;

@property (strong, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextArea;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
