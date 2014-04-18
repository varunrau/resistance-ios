//
//  PlayViewController.h
//  Resistance
//
//  Created by Varun Rau on 12/31/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "PlayerCircleView.h"
#import "PlayerInfoViewController.h"
#import "WYPopoverController.h"

@interface PlayViewController : UIViewController<PlayerCircleViewDelegate, WYPopoverControllerDelegate, TeamAndLadySelectionDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Game *game;

- (void)playerViewTapped:(PlayerView *)playerView;
- (IBAction)actionButtonPressed:(id)sender;

typedef NS_ENUM(NSInteger, VoteClass) {
    TEAM,
    MISSION
};

@end
