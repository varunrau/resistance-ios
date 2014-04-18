//
//  TeamVote.m
//  Resistance
//
//  Created by Varun Rau on 1/8/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import "TeamVote.h"
#import "Vote.h"
#import <RestKit/RestKit.h>

@implementation TeamVote

@synthesize vote;
@synthesize vote_id;
@synthesize public;

- (NSString *) action {
    return [[self vote] intValue] == PASS ? @"accepted" : @"rejected";
}

- (BOOL) isEqual:(id)object {
    if ([object class] != [self class]) {
        return NO;
    }
    return ([[self vote_id] isEqual:[(TeamVote*) object vote_id]]);
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[self class]];
    [playerMapping addAttributeMappingsFromDictionary:@{
                                                        @"vote": @"vote",
                                                        @"id":@"vote_id",
                                                        @"public":@"public"
                                                        }];
    return playerMapping;
}

+ (RKResponseDescriptor *)descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"team_vote" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}

@end
