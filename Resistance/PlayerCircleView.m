//
//  PlayerCircleView.m
//  
//
//  Created by Varun Rau on 1/3/14.
//
//

#import "PlayerCircleView.h"

#define PLAYER_VIEW_HEIGHT 50
#define PLAYER_VIEW_WIDTH 125

@interface PlayerCircleView ()

@property (nonatomic, strong) NSMutableArray *playerViews;

@end

@implementation PlayerCircleView

@synthesize delegate;
@synthesize game;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)setUpSubViews {
    CGPoint center = self.center;
    float radius = self.bounds.size.height / 2 - 50;
    
    int count = 1;
    float angleStep = 2.0f * M_PI / [self.game.players count];
    
    self.playerViews = [[NSMutableArray alloc] init];
    NSMutableArray *gamePlayers = [[NSMutableArray alloc] initWithArray:self.game.players];
    NSMutableArray *later = [[NSMutableArray alloc] init];
    
    for (Player *p in self.game.players) {
        if ([p isEqual:self.game.firstPlayer]) {
            break;
        }
        [later addObject:p];
    }
    
    for (Player *p in later) {
        [gamePlayers removeObject:p];
    }
    
    for (Player *player in gamePlayers) {
        PlayerView *playerView = [[PlayerView alloc] initWithFrame:CGRectMake(10, 10, PLAYER_VIEW_WIDTH, PLAYER_VIEW_HEIGHT) andPlayer:player];
        [playerView setDelegate:self];
        playerView.center = CGPointMake(center.x + cosf(angleStep * count) * radius, (center.y + sinf(angleStep * count) * radius) * 1.4 - PLAYER_VIEW_HEIGHT);
        [self addSubview:playerView];
        [self.playerViews addObject:playerView];
        count++;
    }
    for (Player *player in later) {
        PlayerView *playerView = [[PlayerView alloc] initWithFrame:CGRectMake(10, 10, PLAYER_VIEW_WIDTH, PLAYER_VIEW_HEIGHT) andPlayer:player];
        [playerView setDelegate:self];
        playerView.center = CGPointMake(center.x + cosf(angleStep * count) * radius, (center.y + sinf(angleStep * count) * radius) * 1.4 - PLAYER_VIEW_HEIGHT);
        [self addSubview:playerView];
        [self.playerViews addObject:playerView];
        count++;
    }
}

- (PlayerView *)playerViewForPlayer:(Player *)player {
    int count = 0;
    for (PlayerView *pv in self.playerViews) {
        if ([pv.player.user isEqual:player.user]) {
            return [self.playerViews objectAtIndex:count];
        }
        count++;
    }
    return nil;
}

- (void)playerViewTapped:(PlayerView *)playerView {
    [[self delegate] playerViewTapped:playerView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
