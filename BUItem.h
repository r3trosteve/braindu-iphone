//
//  BUItem.h
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BUChart;

@interface BUItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * link;
@property (nonatomic) float coordx;
@property (nonatomic) float coordy;
@property (nonatomic, retain) BUChart *chart;

@end
