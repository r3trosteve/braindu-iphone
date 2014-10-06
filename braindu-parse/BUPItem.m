//
//  BUPItem.m
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "BUPItem.h"
#import "BUPItemComment.h"

@implementation BUPItem

@synthesize itemComments = _itemComments;

@dynamic owner;
@dynamic image;
@dynamic chart;
@dynamic title;
@dynamic note;
@dynamic viewCount;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([BUPItem class]);
}

#pragma - Async Relationships

- (void)ensureItemComments:(void (^)(NSMutableArray *itemComments))completion
{
    if (_itemComments) {
        if (completion) completion(_itemComments);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:[BUPItemComment parseClassName]];
        [query whereKey:NSStringFromSelector(@selector(item)) equalTo:self];
        
        __weak typeof(self) wSelf = self;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            __strong typeof(self) sSelf = wSelf;
            sSelf.itemComments = [NSMutableArray array];
            [sSelf.itemComments addObjectsFromArray:objects];
            
            if (completion) completion(sSelf.itemComments);
        }];
    }
}


@end
