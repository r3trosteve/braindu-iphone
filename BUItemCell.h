//
//  BUItemCell.h
//  braindu-coredata
//
//  Created by Steven Schofield on 27/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BUChart;
@class BUItem;

@interface BUItemCell : UITableViewCell

- (void)configureCellForItem:(BUItem *)item;

@end
