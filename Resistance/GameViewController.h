//
//  GameViewController.h
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "PlayerView.h"

@interface GameViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Game *game;
@property (nonatomic, strong) IBOutlet UITableView *playersTableView;
@property (nonatomic) IBOutlet UILabel *gameStatus;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *joinGameButton;

- (IBAction)refreshGame:(id)sender;

@end
