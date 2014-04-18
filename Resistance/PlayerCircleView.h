//
//  PlayerCircleView.h
//  
//
//  Created by Varun Rau on 1/3/14.
//
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "PlayerView.h"
#import "Player.h"

@interface PlayerCircleView : UIView<PlayerViewDelegate>

@property (nonatomic, strong) Game *game;
@property (nonatomic, weak) id delegate;

- (void) setUpSubViews;
- (void)playerViewTapped:(PlayerView *)playerView;

- (PlayerView *) playerViewForPlayer:(Player *)player;

@end

@protocol PlayerCircleViewDelegate <NSObject>

- (void)playerViewTapped:(PlayerView *)playerView;

@end