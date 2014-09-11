//
//  BUPItemComment.h
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/Parse.h>

@class BUPItem;
@class BUPUser;

@interface BUPItemComment : PFObject <PFSubclassing>

@property (nonatomic, strong) BUPUser *owner;
@property (nonatomic, strong) BUPItem *item;

@property (nonatomic, copy) NSString *text;

@end
