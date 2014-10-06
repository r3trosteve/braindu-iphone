//
//  BUPItem.h
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/Parse.h>

@class BUPChart;
@class BUPUser;

@interface BUPItem : PFObject <PFSubclassing>

@property (nonatomic, strong) BUPUser *owner;
@property (nonatomic, strong) BUPChart *chart;
@property (nonatomic, strong) NSMutableArray *itemComments;

@property (nonatomic, strong) PFFile *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSNumber *viewCount;

- (void)ensureItemComments:(void (^)(NSMutableArray *itemComments))completion;

@end
