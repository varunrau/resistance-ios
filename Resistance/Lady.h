//
//  Lady.h
//  Resistance
//
//  Created by Varun Rau on 1/23/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "Player.h"

@interface Lady : Player

- (BOOL) isVisibleToPlayer:(Player *)player;
- (BOOL) loyalty;

@end
