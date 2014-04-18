//
//  PlayerInfoViewController.h
//  Resistance
//
//  Created by Varun Rau on 1/7/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Game.h"

@interface PlayerInfoViewController : UIViewController<UIPopoverControllerDelegate, UITextViewDelegate> {
    IBOutlet UIViewController *popoverView;
}

@property Player *player;
@property Game *game;
@property id delegate;

@end

@protocol TeamAndLadySelectionDelegate <NSObject>

- (BOOL) playerIsInTeam:(Player *)player;
- (void) togglePlayer:(Player *)player;
- (void) toggleLady:(Player *)player;
- (BOOL) ladySelected:(Player *)player;

@end
