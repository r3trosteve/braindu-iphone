//
//  BUChart.h
//  braindu-coredata
//
//  Created by Steven Schofield on 27/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BUItem;

@interface BUChart : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSNumber * is_public;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *items;
@end

@interface BUChart (CoreDataGeneratedAccessors)

- (void)addItemsObject:(BUItem *)value;
- (void)removeItemsObject:(BUItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
