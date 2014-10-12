//
//  BUPChart.m
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "BUPChart.h"
#import "BUPItem.h"

@implementation BUPChart

@synthesize items = _items;

@dynamic owner;
@dynamic image;
@dynamic title;
@dynamic body;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([BUPChart class]);
}

#pragma mark - Queries

+ (void)allCharts:(void (^)(NSMutableArray *charts))completion
{
    PFQuery *query = [PFQuery queryWithClassName:[BUPChart parseClassName]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) completion([objects mutableCopy]);
    }];
}



#pragma mark - Async Relationships

- (void)ensureItems:(void (^)(NSMutableArray *items))completion
{
    if (_items) {
        if (completion) completion(_items);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:[BUPItem parseClassName]];
        [query whereKey:NSStringFromSelector(@selector(chart)) equalTo:self];
        [query orderBySortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"voteCount" ascending:NO]];
        __weak typeof(self) wSelf = self;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            __strong typeof(self) sSelf = wSelf;
            sSelf.items = [NSMutableArray array];
            [sSelf.items addObjectsFromArray:objects];
            
            if (completion) completion(sSelf.items);
        }];
    }
}

@end
