//
//  MissionVote.h
//  Resistance
//
//  Created by Varun Rau on 1/8/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MissionVote : NSObject

@property NSNumber *vote;
@property NSNumber *vote_id;

- (NSString *)string;
- (BOOL) isEqual:(id)object;

+ (RKObjectMapping *) mapping;
+ (RKResponseDescriptor *) descriptor;

@end
