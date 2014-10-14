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
#import "BUPItemVote.h"
#import "BUPUser.h"

static NSString * const kUserVotesKey = @"votes";

@implementation BUPItem

@synthesize itemComments = _itemComments;
@synthesize itemVotes = _itemVotes;
@synthesize userLikes = _userLikes;

@dynamic owner;
@dynamic image;
@dynamic chart;
@dynamic title;
@dynamic note;
@dynamic viewCount;
@dynamic voteCount;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([BUPItem class]);
}

#pragma mark - Lazy Getters

- (NSMutableDictionary *)userLikes
{
    if (!_userLikes) {
        _userLikes = [NSMutableDictionary dictionary];
    }
    
    return _userLikes;
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

- (void)ensureItemVotes:(void (^)(NSMutableArray *itemVotes))completion
{
    if (_itemVotes) {
        if (completion) completion(_itemVotes);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:[BUPItemVote parseClassName]];
        [query whereKey:NSStringFromSelector(@selector(item)) equalTo:self];
        
        __weak typeof(self) wSelf = self;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            __strong typeof(self) sSelf = wSelf;
            
            sSelf.itemVotes = [NSMutableArray array];
            [sSelf.itemVotes addObjectsFromArray:objects];
            
            if (completion) completion(sSelf.itemVotes);
        }];
    }

}

#pragma mark - Other Queries

- (void)voteWithUser:(BUPUser *)user withCompletionBlock:(void (^)(NSError *error))completion
{
    self.userLikes[user.objectId] = @(YES);
    
    PFRelation *relation = [user relationForKey:kUserVotesKey];
    [relation addObject:self];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self.userLikes removeObjectForKey:user.objectId];
        }
        
        if (completion) completion(error);
    }];
}

- (void)unvoteWithUser:(BUPUser *)user withCompletionBlock:(void (^)(NSError *error))completion
{
    [self.userLikes removeObjectForKey:user.objectId];
    
    PFRelation *relation = [user relationForKey:kUserVotesKey];
    [relation removeObject:self];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            self.userLikes[user.objectId] = @(YES);
        }
        
        if (completion) completion(error);
    }];
}

- (void)testUser:(BUPUser *)user votesForItem:(void (^)(BOOL userLikesItem, NSError *error))completion
{
    if (!completion) {
        return;
    }
    
    if ([self.userLikes[user.objectId] boolValue] == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES, nil);
        });
        return;
    }
    
    PFRelation *relation = [user relationForKey:kUserVotesKey];
    PFQuery *scope = [relation query];
    [scope whereKey:NSStringFromSelector(@selector(objectId)) equalTo:self.objectId];
    [scope countObjectsInBackgroundWithBlock:^(int number, NSError *qError) {
        BOOL votesFor = number > 0;
        if (votesFor) {
            self.userLikes[user.objectId] = @(YES);
        }
        
        completion(votesFor, qError);
    }];
    
}


@end
