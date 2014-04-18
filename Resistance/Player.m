//
//  Player.m
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "Player.h"
#import "TeamVote.h"
#import "MissionVote.h"

@implementation Player

@synthesize position;
@synthesize name;
@synthesize user;
@synthesize teamVotes;
@synthesize missionVotes;
@synthesize loyalty;

- (BOOL) isEqual:(id)object {
    if ([object class] != [self class]) {
        return NO;
    }
    return ([[self player_id] isEqual:[(Player *) object player_id]]);
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[self class]];
    [playerMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"name",
                                                        @"position": @"position",
                                                        @"id":@"player_id",
                                                        @"loyalty":@"loyalty"
                                                        }];
    [playerMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:User.mapping]];
    [playerMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"team_votes" toKeyPath:@"teamVotes" withMapping:TeamVote.mapping]];
    [playerMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"mission_votes" toKeyPath:@"missionVotes" withMapping:MissionVote.mapping]];
    return playerMapping;
}

+ (RKResponseDescriptor *)descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"players" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}

@end
