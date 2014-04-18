//
//  Team.m
//  Resistance
//
//  Created by Varun Rau on 1/1/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import "Team.h"
#import "Player.h"
#import "TeamVote.h"

@implementation Team

@synthesize players;
@synthesize votes;

- (NSString *) string {
    NSString *repr = @"";
    for (Player *p in [self players]) {
        repr = [repr stringByAppendingString:p.name];
        if ([p isEqual:[[self players] lastObject]]) {
            break;
        }
        if ([p isEqual:[[self players] objectAtIndex:[[self players] count] - 2]]) {
            repr = [repr stringByAppendingString:@" and "];
        } else {
            repr = [repr stringByAppendingString:@", "];
        }
    }
    return repr;
}

+ (RKObjectMapping *)mapping {
    RKObjectMapping *teamMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [teamMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"players" toKeyPath:@"players" withMapping:Player.mapping]];
    [teamMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"votes" toKeyPath:@"votes" withMapping:TeamVote.mapping]];
    return teamMapping;
}

+ (RKResponseDescriptor *)descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:self.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"team" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}


@end
