//
//  Round.m
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "Round.h"
#import "Team.h"
#import "Vote.h"
#import "MissionVote.h"

@implementation Round

@synthesize voteRoundNumber;
@synthesize leader;
@synthesize missionPlayers;
@synthesize status;
@synthesize teams;
@synthesize missionPlayerCount;

+ (RKObjectMapping *)mapping {
    RKObjectMapping *roundMapping = [RKObjectMapping mappingForClass:[self class]];
    [roundMapping addAttributeMappingsFromDictionary:@{
                                                        @"vote_round_number":@"voteRoundNumber",
                                                        @"num_mission_players":@"missionPlayerCount",
                                                        @"status": @"status"
                                                        }];
    [roundMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"teams" toKeyPath:@"teams" withMapping:Team.mapping]];
    [roundMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"mission_players" toKeyPath:@"missionPlayers" withMapping:Player.mapping]];
    [roundMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"mission_votes" toKeyPath:@"missionVotes" withMapping:MissionVote.mapping]];
    [roundMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"leader" toKeyPath:@"leader" withMapping:Player.mapping]];
    return roundMapping;
}

+ (RKResponseDescriptor *)descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"rounds" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}


@end
