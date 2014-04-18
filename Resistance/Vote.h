//
//  Vote.h
//  Resistance
//
//  Created by Varun Rau on 1/7/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "Player.h"
#import "Round.h"

@interface Vote : NSObject

@property (nonatomic, strong) Round *round;
@property (nonatomic, strong) NSNumber *vote;

typedef NS_ENUM(NSInteger, VoteType) {
    FAIL,
    PASS
};

+ (RKObjectMapping *) mapping;
+ (RKResponseDescriptor *) descriptor;

@end
