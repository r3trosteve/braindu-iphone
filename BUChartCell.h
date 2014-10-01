//
//  BUChartCell.h
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BUPChart;
@class BUPUser;

@interface BUChartCell : UITableViewCell

- (void)configureCellForChart:(BUPChart *)chart;

@end
