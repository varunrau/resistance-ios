//
//  TeamVote.h
//  Resistance
//
//  Created by Varun Rau on 1/8/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "Team.h"

@interface TeamVote : NSObject

@property NSNumber *vote;
@property NSNumber *vote_id;
@property (nonatomic, strong) NSNumber *public;

- (NSString *) action;
- (BOOL) isEqual:(id)object;

+ (RKObjectMapping *) mapping;
+ (RKResponseDescriptor *) descriptor;

@end
