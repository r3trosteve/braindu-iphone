//
//  BUPUser.h
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/Parse.h>

@interface BUPUser : PFUser <PFSubclassing>

@property (nonatomic, strong) NSMutableArray *charts;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *itemComments;

@property (nonatomic, copy) NSString *displayName;

+ (NSString *)parseClassName;

- (void)ensureCharts:(void (^)(NSMutableArray *charts))completion;

@end
