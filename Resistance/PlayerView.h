//
//  PlayerView.h
//  Resistance
//
//  Created by Varun Rau on 12/31/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface PlayerView : UIView

@property (nonatomic, weak) id delegate;

- (id)initWithFrame:(CGRect)frame andPlayer:(Player *)p;
- (void)addLeaderIcon;
- (void)addTeamIcon;
- (void)removeLeaderIcon;
- (void)removeTeamIcon;
- (void)setImage:(UIImage *)image;

@property Player *player;

@end

@protocol PlayerViewDelegate <NSObject>

- (void)playerViewTapped:(PlayerView *)playerView;

@end