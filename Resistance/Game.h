//
//  Game.h
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Player.h"
#import "Round.h"
#import "User.h"

@interface Game : NSObject

@property (nonatomic) int game_id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *players;
@property (nonatomic) NSMutableArray *rounds;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) Player *lady;
@property (nonatomic, strong) Player *firstPlayer;
@property (nonatomic, strong) NSMutableArray *pastLadies;

- (BOOL) userInGame:(User *)user;
- (BOOL) inProgress;

- (BOOL) userShouldVote:(User *)user;
- (BOOL) userShouldSelectTeam:(User *)user;
- (BOOL) userShouldSelectLady:(User *)user;
- (BOOL) validLady:(Player *)player;

- (Player *)leader;
- (Round *)currentRound;

typedef NS_ENUM(NSInteger, GameStateType) {
    NOT_STARTED,
    LEADER,
    TEAM_VOTE,
    MISSION_VOTE,
    LADY_OF_THE_LAKE,
    ENDED
};

+ (RKObjectMapping *) mapping;
+ (RKResponseDescriptor *) descriptor;
+ (RKResponseDescriptor *) full_descriptor;

@end
