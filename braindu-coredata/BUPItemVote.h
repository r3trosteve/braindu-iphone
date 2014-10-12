//
//  BUPItemVote.h
//  braindu-coredata
//
//  Created by Steven Schofield on 12/10/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/Parse.h>

@class BUPItem;
@class BUPUser;

@interface BUPItemVote : PFObject <PFSubclassing>

@property (nonatomic, strong) BUPUser *owner;
@property (nonatomic, strong) BUPItem *item;

@end
