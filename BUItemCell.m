//
//  BUItemCell.m
//  braindu-coredata
//
//  Created by Steven Schofield on 27/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "BUItemCell.h"
#import "BUPChart.h"
#import "BUPItem.h"

@interface BUItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BUItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:.55];
        
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

- (void) configureCellForItem:(BUPItem *)item {
    self.titleLabel.text = item.title;
    
}

@end
