//
//  Player.h
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "User.h"
#import "Vote.h"

@interface Player : NSObject

@property (nonatomic) NSString *position;
@property (nonatomic) NSString *name;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSNumber *player_id;
@property (nonatomic, strong) NSMutableArray *teamVotes;
@property (nonatomic, strong) NSMutableArray *missionVotes;
@property (nonatomic, strong) NSNumber *loyalty;

- (BOOL) isEqual:(id)object;


+ (RKObjectMapping *)mapping;
+ (RKResponseDescriptor *) descriptor;

@end
