//
//  BUPItemVote.m
//  braindu-coredata
//
//  Created by Steven Schofield on 12/10/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//
#import <Parse/PFObject+Subclass.h>
#import "BUPItemVote.h"

@implementation BUPItemVote

@dynamic owner;
@dynamic item;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([BUPItemVote class]);
}


@end
