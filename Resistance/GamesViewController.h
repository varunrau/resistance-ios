//
//  GamesViewController.h
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "Game.h"

@interface GamesViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *games;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *actionButton;

- (IBAction)presentActionSheet:(id)sender;

@end
