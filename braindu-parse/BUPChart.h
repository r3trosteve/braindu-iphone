//
//  BUPChart.h
//  braindu-coredata
//
//  Created by Hunter Bridges on 9/10/14.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Parse/Parse.h>

@class BUPUser;

@interface BUPChart : PFObject <PFSubclassing>

@property (nonatomic, strong) BUPUser *owner;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) PFFile *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

+ (NSString *)parseClassName;
+ (void)allCharts:(void (^)(NSMutableArray *charts))completion;

- (void)ensureItems:(void (^)(NSMutableArray *items))completion;

@end
