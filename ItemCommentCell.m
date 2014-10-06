//
//  itemCommentCell.m
//  braindu-coredata
//
//  Created by Steven Schofield on 05/10/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "ItemCommentCell.h"
#import "BUPChart.h"
#import "BUPItem.h"
#import "BUPItemComment.h"
#import "BUPUser.h"

@implementation ItemCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellForItemComment:(BUPItemComment *)itemComment {
    // self.userAvatarImageView.image = ;
    
    UIImage *image = [UIImage imageNamed:@"steve.jpg"];
    self.userAvatarImageView.image = image;
    
    
    self.commentTextLabel.text = itemComment.text;
    
    [itemComment.owner fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if (itemComment.owner.avatar) {
                PFFile *file = [object objectForKey:@"avatar"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data];
                    self.userAvatarImageView.image = image;
                }];
            }
            self.usernameLabel.text = itemComment.owner.username;
        }
    }];
    
    
}

@end
