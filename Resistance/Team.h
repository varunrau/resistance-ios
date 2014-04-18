//
//  Team.h
//  Resistance
//
//  Created by Varun Rau on 1/1/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Team : NSObject

@property (nonatomic) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *votes;

- (NSString *) string;

+ (RKObjectMapping *)mapping;
+ (RKResponseDescriptor *) descriptor;

@end
