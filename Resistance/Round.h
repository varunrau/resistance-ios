//
//  Round.h
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Team.h"

@class Player;

@interface Round : NSObject

@property (nonatomic, strong) Player *leader;
@property (nonatomic, strong) NSMutableArray *missionPlayers;
@property (nonatomic, strong) NSMutableArray *missionVotes;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSMutableArray *teams;
@property int voteRoundNumber;
@property NSNumber *missionPlayerCount;

+ (RKObjectMapping *)mapping;
+ (RKResponseDescriptor *) descriptor;

@end
