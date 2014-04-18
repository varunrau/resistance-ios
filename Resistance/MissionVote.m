//
//  MissionVote.m
//  Resistance
//
//  Created by Varun Rau on 1/8/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import "MissionVote.h"

@implementation MissionVote

@synthesize vote;

- (BOOL) isEqual:(id)object {
    if ([object class] != [self class]) {
        return NO;
    }
    return ([[self vote_id] isEqual:[(MissionVote *) object vote_id]]);
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[self class]];
    [playerMapping addAttributeMappingsFromDictionary:@{
                                                        @"vote": @"vote",
                                                        @"id":@"vote_id"
                                                        }];
    return playerMapping;
}

+ (RKResponseDescriptor *)descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"mission_vote" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}
@end
