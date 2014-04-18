//
//  Game.m
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "Game.h"
#import "Round.h"
#import "TeamVote.h"
#import "MissionVote.h"
#import "Lady.h"

@implementation Game

@synthesize game_id;
@synthesize name;
@synthesize rounds;
@synthesize players;
@synthesize status;
@synthesize state;
@synthesize lady;
@synthesize firstPlayer;
@synthesize pastLadies;

- (BOOL) userInGame:(User *)user {
    for (Player *player in self.players) {
        if ([[player user] isEqual:user]) {
            return YES;
        }
    }
    return NO;
}

- (Player *) playerForUser:(User *)user {
    for (Player *player in self.players) {
        if ([[player user] isEqual:user]) {
            return player;
        }
    }
    return nil;
}

- (Player *)leader {
    return [[self currentRound] leader];
}

- (Round *)currentRound {
    return [self.rounds lastObject];
}

- (BOOL) inProgress {
    return self.rounds != nil;
}

- (BOOL)userShouldVote:(User *)user {
    Player *player = [self playerForUser:user];
    if ([self.state intValue] == TEAM_VOTE) {
        for (TeamVote *roundVote in [[[[self currentRound] teams] lastObject] votes]) {
            for (TeamVote *playerVote in [player teamVotes]) {
                if ([roundVote isEqual:playerVote]) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([[self state] intValue] == MISSION_VOTE) {
        if ([[[self currentRound] missionPlayers] containsObject:player]) {
            for (MissionVote *roundVote in [[self currentRound] missionVotes]) {
                for (MissionVote *playerVote in [player missionVotes]) {
                    if ([playerVote isEqual:roundVote]) {
                        return NO;
                    }
                }
            }
            return YES;
        }
        return NO;
    }
    return NO;
}

- (BOOL)userShouldSelectTeam:(User *)user {
    return self.state == [NSNumber numberWithInt:LEADER] && [[[self leader] user] isEqual:user];
}

- (BOOL)userShouldSelectLady:(User *)user {
    return self.state == [NSNumber numberWithInt:LADY_OF_THE_LAKE] && [[[self lady] user] isEqual:user];
}

- (BOOL) validLady:(Player *)player {
    for (Player *p in self.pastLadies) {
        if ([p isEqual:player]) {
            return NO;
        }
    }
    return YES;
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *gameMapping = [RKObjectMapping mappingForClass:[self class]];
    [gameMapping addAttributeMappingsFromDictionary:@{@"name": @"name",
                                                      @"state":@"state",
                                                      @"status": @"status",
                                                      @"id": @"game_id"}];
    
    [gameMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"players" toKeyPath:@"players" withMapping:Player.mapping]];
    [gameMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rounds" toKeyPath:@"rounds" withMapping:Round.mapping]];
    [gameMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"lady" toKeyPath:@"lady" withMapping:Player.mapping]];
    [gameMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"first_player" toKeyPath:@"firstPlayer" withMapping:Player.mapping]];
    [gameMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ladies" toKeyPath:@"pastLadies" withMapping:Lady.mapping]];
    return gameMapping;
}


+ (RKResponseDescriptor *)full_descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"game" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}

+ (RKResponseDescriptor *)descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"games" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}
@end
