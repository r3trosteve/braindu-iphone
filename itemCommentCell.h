//
//  itemCommentCell.h
//  braindu-coredata
//
//  Created by Steven Schofield on 05/10/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APAvatarImageView.h"

@class BUPChart;
@class BUPItem;
@class BUPUser;
@class BUPItemComment;


@interface ItemCommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet APAvatarImageView *userAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeSubmittedLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;

- (void) configureCellForItemComment:(BUPItemComment *)itemComment;

@end
