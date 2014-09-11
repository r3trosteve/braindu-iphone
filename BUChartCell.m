//
//  BUChartCell.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "BUChartCell.h"
#import "BUPChart.h"

@interface BUChartCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chartImage;


@end

@implementation BUChartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:24]];
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
    
    self.chartImage.image = [UIImage imageNamed:@"chartPlaceholder"];
    if (chart.image) {
        [chart.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            self.chartImage.image = image;
        }];
    }
}

@end
