//
//  BUChartCell.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "BUChartCell.h"
#import "BUChart.h"

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

- (void) configureCellForChart:(BUChart *)chart {
    self.titleLabel.text = chart.title;
    
    if (chart.imageData) {
        self.chartImage.image = [UIImage imageWithData:chart.imageData];
    } else {
        self.chartImage.image = [UIImage imageNamed:@"chartPlaceholder"];
    }
}

@end
