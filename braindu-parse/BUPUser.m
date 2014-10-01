//
//  BUPUser.m
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "BUPUser.h"
#import "BUPChart.h"

@implementation BUPUser

@synthesize charts = _charts;
@synthesize items = _items;
@synthesize itemComments = _itemComments;

@dynamic displayName;
@dynamic avatar;
@dynamic banner;
@dynamic location;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return [PFUser parseClassName];
}

#pragma - Async Relationships

- (void)ensureCharts:(void (^)(NSMutableArray *charts))completion
{
    if (_charts) {
        if (completion) completion(_charts);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:[BUPChart parseClassName]];
        [query whereKey:NSStringFromSelector(@selector(owner)) equalTo:self];
        
        __weak typeof(self) wSelf = self;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            __strong typeof(self) sSelf = wSelf;
            sSelf.charts = [NSMutableArray array];
            [sSelf.charts addObjectsFromArray:objects];
            
            if (completion) completion(sSelf.charts);
        }];
    }
}

@end
