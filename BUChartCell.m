//
//  BUChartCell.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "BUChartCell.h"
#import "BUPChart.h"
#import "APAvatarImageView.h"
#import "BUPUser.h"
#import "Defines.h"

@interface BUChartCell ()

@property (strong, nonatomic) BUPUser *user;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *itemCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chartImage;
@property (weak, nonatomic) IBOutlet APAvatarImageView *userAvatar;


@end

@implementation BUChartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.titleLabel setFont:CHART_TITLE_FONT];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellForChart:(BUPChart *)chart {
    self.titleLabel.text = chart.title;
    UIImage *image = [UIImage imageNamed:@"steve.jpg"];
    self.userAvatar.image = image;
    
    self.chartImage.image = [UIImage imageNamed:@"chartPlaceholder"];
    
    
    [chart.owner fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if (chart.owner.avatar) {
                PFFile *file = [object objectForKey:@"avatar"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data];
                    self.userAvatar.image = image;
                }];
            }
//            if (!chart.image) {
//                PFFile *file = [object objectForKey:@"image"];
//                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                    UIImage *image = [[UIImage alloc] initWithData:data];
//                    self.chartImage.image = image;
//                }];
//            }
        }
//
    }];
    
    
//    if (chart.owner.avatar) {
//        [chart.owner.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            UIImage *image = [[UIImage alloc] initWithData:data];
//            self.userAvatar.image = image;
//        }];
//    }
    
    if (chart.image) {
        
        [chart.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            self.chartImage.image = image;
        }];
    }

    self.itemCountLabel.titleLabel.text = [NSString stringWithFormat:@"%lu items", (unsigned long)[chart.items count]];
    
    
}


@end
