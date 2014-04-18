//
//  PlayerView.m
//  Resistance
//
//  Created by Varun Rau on 12/31/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PlayerView.h"

#define LABEL_HEIGHT 20

@interface PlayerView ()

@property (nonatomic, strong) UIImageView *playerImage;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)viewTapped:(UITapGestureRecognizer *) tapGesture;

@end

@implementation PlayerView {
    BOOL isLeader;
    BOOL isOnTeam;
}

@synthesize playerImage;
@synthesize nameLabel;
@synthesize nameView;
@synthesize player;

- (id)initWithFrame:(CGRect)frame andPlayer:(Player *)p
{
    self = [super initWithFrame:frame];
    if (self) {
        self.player = p;
        isLeader = NO;
        isOnTeam = NO;
        
        UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2, 0, frame.size.width / 4, frame.size.height - LABEL_HEIGHT)];
        [imageView1 setImage:[UIImage imageNamed:@"player.png"]];
        imageView1.center = CGPointMake(frame.size.width / 2, (frame.size.height - LABEL_HEIGHT) / 2);
        self.playerImage = imageView1;
        [self addSubview:imageView1];
        
        self.nameView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - LABEL_HEIGHT, frame.size.width, LABEL_HEIGHT)];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, LABEL_HEIGHT)];
        self.nameLabel.text = player.name;
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [self.nameLabel.font fontWithSize:12];
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.nameView addSubview:self.nameLabel];
        [self addSubview:self.nameView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(viewTapped:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        self.layer.borderWidth = 3.0f;
    }
    return self;
}

- (void) addLeaderIcon {
    isLeader = YES;
    if (isOnTeam) {
        [self setImage:[UIImage imageNamed:@"team_and_player.png"]];
    } else {
        [self setImage:[UIImage imageNamed:@"leader.png"]];
    }
}

- (void) addTeamIcon {
    if (isLeader) {
        [self setImage:[UIImage imageNamed:@"team_and_leader.png"]];
    } else {
        [self setImage:[UIImage imageNamed:@"team.png"]];
    }
}

- (void)removeLeaderIcon {
    isLeader = NO;
    if (isOnTeam) {
        [self setImage:[UIImage imageNamed:@"team.png"]];
    } else {
        [self setImage:[UIImage imageNamed:@"player.png"]];
    }
}
- (void)removeTeamIcon {
    isOnTeam = NO;
    if (isLeader) {
        [self setImage:[UIImage imageNamed:@"leader.png"]];
    } else {
        [self setImage:[UIImage imageNamed:@"player.png"]];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGesture {
    [[self delegate] playerViewTapped:self];
}

- (void)setImage:(UIImage *)image {
    self.playerImage.image = image;
}


@end
