//
//  BUPItem.m
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "BUPItem.h"

@implementation BUPItem

@synthesize itemComments = _itemComments;

@dynamic owner;
@dynamic chart;
@dynamic title;
@dynamic viewCount;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([BUPItem class]);
}

@end
