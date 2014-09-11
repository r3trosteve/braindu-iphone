//
//  BUPItemComment.m
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "BUPItemComment.h"

@implementation BUPItemComment

@dynamic owner;
@dynamic item;
@dynamic text;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([BUPItemComment class]);
}

@end
