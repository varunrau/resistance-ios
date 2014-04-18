//
//  PlayerInfoViewController.m
//  Resistance
//
//  Created by Varun Rau on 1/7/14.
//  Copyright (c) 2014 Rafael and Rau. All rights reserved.
//

#import "PlayerInfoViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "TeamVote.h"

@interface PlayerInfoViewController ()

@property UITextView *playerHistory;
@property UISegmentedControl *segmentControl;

@end

@implementation PlayerInfoViewController

@synthesize game;
@synthesize player;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.player.name;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.view.frame;
    self.playerHistory = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.playerHistory.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    self.playerHistory.delegate = self;
    self.playerHistory.editable = NO;
    self.playerHistory.scrollEnabled = YES;
    self.playerHistory.userInteractionEnabled = YES;
    self.playerHistory.clipsToBounds = NO;
    [self.view addSubview:self.playerHistory];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.game.state intValue] == LEADER) {
        if ([self.game userShouldSelectTeam:[(AppDelegate *)[[UIApplication sharedApplication] delegate] user]]) {
            if ([self.delegate playerIsInTeam:player]) {
                [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Remove Player" style:UIBarButtonItemStylePlain target:self action:@selector(playerSelected:)]];
            } else {
                [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Add Player" style:UIBarButtonItemStylePlain target:self action:@selector(playerSelected:)]];
            }
        }
    } else if ([self.game.state intValue] == LADY_OF_THE_LAKE) {
        if ([self.game userShouldSelectLady:[(AppDelegate *)[[UIApplication sharedApplication] delegate] user]]) {
            if ([self.game validLady:self.player]) {
                if ([self.delegate ladySelected:self.player]) {
                    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Deselect Lady" style:UIBarButtonItemStylePlain target:self action:@selector(ladyChosen:)]];
                } else {
                    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Select Lady" style:UIBarButtonItemStylePlain target:self action:@selector(ladyChosen:)]];
                }
            }
        }
    }
    [self updatePlayerHistoryText];
}

- (void) updatePlayerHistoryText {
    NSString *history = @"";
    for (int r = 0; r < [[[self game] rounds] count]; r++) {
        Round *round = [[[self game] rounds] objectAtIndex:r];
        history = [history stringByAppendingString:[NSString stringWithFormat:@"Round %d\n", r + 1]];
//        for (Player *missionPlayer in [round missionPlayers]) {
//            if ([[missionPlayer user] isEqual:[[self player] user]]) {
//                history = [history stringByAppendingString:[NSString stringWithFormat:@"\t%@ %@ a team that %@.\n", [[self player] name], [[[[self player] missionVotes] objectAtIndex:r] string], [round status]]];
//            }
//        }
        for (Team *team in [round teams]) {
            for (TeamVote *vote in [team votes]) {
                for (TeamVote *playerVote in [[self player] teamVotes]) {
                    if ([vote isEqual:playerVote] && [[playerVote public] boolValue]) {
                        history = [history stringByAppendingString:[NSString stringWithFormat:@"\t%@ %@ a team consisting of %@.\n", [[self player] name], [playerVote action], [team string]]];
                    }
                }
            }
        }
    }
    
    
    [[self playerHistory] setText:history];
    CGSize stringSize = [history sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]
                               constrainedToSize:CGSizeMake(self.view.frame.size.width, 9999)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    self.playerHistory.frame = CGRectMake(0, 0, stringSize.width + 10, stringSize.height + 10);
}

- (void) playerSelected:(id) sender {
    [self.delegate togglePlayer:self.player];
    if ([self.delegate playerIsInTeam:player]) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Remove Player" style:UIBarButtonItemStylePlain target:self action:@selector(playerSelected:)]];
    } else {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Add Player" style:UIBarButtonItemStylePlain target:self action:@selector(playerSelected:)]];
    }
}

- (void) ladyChosen:(id) sender {
    [self.delegate toggleLady:self.player];
    if ([self.delegate ladySelected:self.player]) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Deselect Player" style:UIBarButtonItemStylePlain target:self action:@selector(ladyChosen:)]];
    } else {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Select Player" style:UIBarButtonItemStylePlain target:self action:@selector(ladyChosen:)]];
    }
}

@end
