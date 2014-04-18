//
//  PlayViewController.m
//  Resistance
//
//  Created by Varun Rau on 12/31/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayerView.h"
#import "AppDelegate.h"
#import "TSMessage.h"
#import "PlayerInfoViewController.h"

@interface PlayViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) IBOutlet PlayerCircleView *playerCircleView;
@property (nonatomic, strong) IBOutlet UILabel *gameStatus;
@property (nonatomic, strong) WYPopoverController *popover;
@property (nonatomic, strong) NSMutableArray *team;
@property (nonatomic, strong) Player *lady;

- (void)viewTapped:(UITapGestureRecognizer *)tap;

@end

@implementation PlayViewController

@synthesize scrollView;
@synthesize refreshControl;
@synthesize game;
@synthesize playerCircleView;
@synthesize team;
@synthesize lady;

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
    self.navigationController.navigationBar.translucent = NO;
    UIRefreshControl *rControl = [[UIRefreshControl alloc] init];
    [rControl addTarget:self action:@selector(refreshGame:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rControl;
    [self.scrollView addSubview:self.refreshControl];
    [TSMessage setDefaultViewController:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(viewTapped:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    self.team = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setupPlayerViews];
    self.gameStatus.text = self.game.status;
    self.title = self.game.name;
    self.scrollView.contentSize = self.playerCircleView.frame.size;
    [self.scrollView addSubview:self.playerCircleView];
    [self pullGame:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.playerCircleView setGame:self.game];
}

- (void) setupPlayerViews {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat x = screenBounds.size.width;
    CGFloat y = screenBounds.size.height / 2;
    self.playerCircleView = [[PlayerCircleView alloc] initWithFrame:CGRectMake(0, 0, x, y)];
    [self.playerCircleView setDelegate:self];
    [self.playerCircleView setGame:self.game];
    [self.playerCircleView setUpSubViews];
    [[self.playerCircleView playerViewForPlayer:[self.game leader]] addLeaderIcon];
    [self setTeamIcons];
    [self.view addSubview:self.playerCircleView];
}

- (void)refreshGame: (UIRefreshControl *)refreshControl {
    [self.refreshControl beginRefreshing];
    [self pullGame:YES];
}

- (void)refreshView {
    self.gameStatus.text = self.game.status;
    [self.playerCircleView setGame:self.game];
    User *currentUser = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user];
    
    switch ([self.game.state intValue]) {
        case NOT_STARTED:
            self.gameStatus.text = @"This game has not yet started";
            break;
        case LEADER:
            if ([self.game userShouldSelectTeam:currentUser]) {
                self.gameStatus.text = @"Waiting for you to select a team";
            } else {
                self.gameStatus.text = [NSString stringWithFormat:@"Waiting for %@ to select a team", [[self.game leader] name]];
            }
            break;
        case TEAM_VOTE:
            if ([self.game userShouldVote:currentUser]) {
                self.gameStatus.text = @"Waiting for you to vote on the team";
            } else {
                self.gameStatus.text = @"Waiting on other people to vote on the team";
            }
            self.team = [[[[self.game.rounds lastObject] teams] lastObject] players];
            break;
        case MISSION_VOTE:
            if ([self.game userShouldVote:currentUser]) {
                self.gameStatus.text = @"Waiting for you to vote on the mission";
            } else {
                self.gameStatus.text = @"Waiting for the players to return from the mission";
            }
            self.team = [[[[self.game.rounds lastObject] teams] lastObject] players];
            break;
        case LADY_OF_THE_LAKE:
            if ([[self game] userShouldSelectLady:currentUser]) {
                self.gameStatus.text = @"Waiting for you to select a lady";
            } else {
                self.gameStatus.text = [NSString stringWithFormat:@"Waiting for %@ to select a lady", [[[self game] lady] name]];
            }
            break;
        case ENDED:
            self.gameStatus.text = @"This game has ended.";
        default:
            self.gameStatus.text = @"Great Scott something has gone horribly wrong!";
            break;
    }    
    [self.playerCircleView setUpSubViews];
    [[self.playerCircleView playerViewForPlayer:[self.game leader]] addLeaderIcon];
    [self setTeamIcons];

    [self.refreshControl endRefreshing];
}

- (void)setTeamIcons {
    for (Player *p in self.game.players) {
        PlayerView *view = [self.playerCircleView playerViewForPlayer:p];
        [view removeTeamIcon];
    }
    for (Player *p in self.team) {
        PlayerView *view = [self.playerCircleView playerViewForPlayer:p];
        [view addTeamIcon];
    }
}

- (void)pullGame:(BOOL)displayMessage {
    NSString *getURL = @"game/";
    getURL = [getURL stringByAppendingFormat:@"%d", self.game.game_id];
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]
                                    requestWithObject:nil
                                    method:RKRequestMethodGET
                                    path:getURL
                                    parameters:nil];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[Game.full_descriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"pulled successfully full game data");
        [self setGame:[result.dictionary objectForKey:@"game"]];
        [self refreshView];
        if ([result.dictionary objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[result.dictionary objectForKey:@"message"]
                                        subtitle:nil
                                            type:TSMessageNotificationTypeSuccess];
        }
        if (displayMessage) {
            [TSMessage showNotificationWithTitle:@"Game is up-to-date"
                                    subtitle:nil
                                        type:TSMessageNotificationTypeMessage];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error pulling game data");
        [TSMessage showNotificationWithTitle:@"There was an error retrieving the game data!"
                                    subtitle:nil
                                        type:TSMessageNotificationTypeError];
        [self.refreshControl endRefreshing];
    }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (BOOL) currentUserIsLeader {
    return [[[self.game leader] user] isEqual:[(AppDelegate *)[[UIApplication sharedApplication] delegate] user]];
}

- (void)playerViewTapped:(PlayerView *)playerView {
    PlayerInfoViewController *pinfoVC = [[PlayerInfoViewController alloc] init];
    [pinfoVC setPlayer:[playerView player]];
    [pinfoVC setDelegate:self];
    [pinfoVC setGame:self.game];
    pinfoVC.modalInPopover = NO;
    pinfoVC.preferredContentSize = CGSizeMake(280, 200);
    
    UINavigationController* contentViewController = [[UINavigationController alloc] initWithRootViewController:pinfoVC];

    WYPopoverController *popoverController = [[WYPopoverController alloc] initWithContentViewController:contentViewController];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:playerView.frame
                             inView:self.playerCircleView
           permittedArrowDirections:WYPopoverArrowDirectionAny
                           animated:YES
                            options:WYPopoverAnimationOptionFadeWithScale];
    self.popover = popoverController;
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    // Delegate Method
}

- (void)viewTapped:(UITapGestureRecognizer *)tap {
    if (self.popover) {
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    }
}

#pragma mark - Action Sheet Methods

- (IBAction)actionButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an action"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    int cancelIndex = 0;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    User *currentUser = [(AppDelegate *) [[UIApplication sharedApplication] delegate] user];
    switch ([self.game.state intValue]) {
        case LEADER:
            if ([self currentUserIsLeader]) {
                [actionSheet addButtonWithTitle:@"Send Selected Team"];
                cancelIndex++;
            }
            break;
        case TEAM_VOTE:
            if ([self.game userShouldVote:currentUser]) {
                [actionSheet addButtonWithTitle:@"Vote on this team"];
                cancelIndex++;
            }
            break;
        case MISSION_VOTE:
            // Should check to make sure that this player is on the mission
            if ([self.game userShouldVote:currentUser]) {
                [actionSheet addButtonWithTitle:@"Vote on the mission"];
                cancelIndex++;
            }
            break;
        case LADY_OF_THE_LAKE:
            if ([self.game userShouldSelectLady:currentUser]) {
                [actionSheet addButtonWithTitle:@"Select the next Lady"];
                cancelIndex++;
            }
            break;
        default:
            break;
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = cancelIndex;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Send Selected Team"]) {
        if ([self currentUserIsLeader] && [self validateTeam]) {
            [self submitTeam];
        } else {
            [TSMessage showNotificationWithTitle:@"That is not a valid team!"
                                        subtitle:[NSString stringWithFormat:@"You need %d players.", [[[self.game currentRound] missionPlayerCount] intValue]]
                                            type:TSMessageNotificationTypeError];
            
        }
    } else if ([buttonTitle isEqualToString:@"Vote on this team"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Vote"
                              message:@"Would you like to approve or reject this team?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Approve", @"Reject", nil];
        alert.delegate = self;
        [alert show];

    } else if ([buttonTitle isEqualToString:@"Vote on the mission"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Vote"
                              message:@"Would you like to pass or fail this mission?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Pass", @"Fail", nil];
        alert.delegate = self;
        [alert show];
    }
    NSLog(@"%d", buttonIndex);
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView message] isEqualToString:@"Would you like to approve or reject this team?"]) {
        switch (buttonIndex) {
            case 0:
                // Cancel
                break;
            case 1:
                [self submitVote:1 ofType:TEAM];
                break;
            case 2:
                [self submitVote:0 ofType:TEAM];
                break;
            default:
                break;
        }

    } else if ([[alertView message] isEqualToString:@"Would you like to pass or fail this mission?"]) {
        switch (buttonIndex) {
            case 0:
                // Cancel
                break;
            case 1:
                [self submitVote:1 ofType:MISSION];
                break;
            case 2:
                [self submitVote:0 ofType:MISSION];
                break;
            default:
                break;
        }
    }
}

- (void) submitVote:(int) vote ofType:(VoteClass) type {
    switch (type) {
        case MISSION:
            [self missionVote:vote];
            break;
        case TEAM:
            [self teamVote:vote];
            break;
        default:
            NSLog(@"fuck");
            break;
    }
}

- (void) missionVote:(int) vote {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    
    NSDictionary *params = @{@"game_id": [NSNumber numberWithInt:self.game.game_id],
                             @"vote":[NSNumber numberWithInt:vote]};
    NSString *path = [NSString stringWithFormat:@"game/%d/mission_vote", self.game.game_id];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    AFJSONRequestOperation *missionVote = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[json objectForKey:@"message"]
                                        subtitle:[json objectForKey:@"subtitle"]
                                            type:TSMessageNotificationTypeSuccess];
        }
        [self pullGame:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[json objectForKey:@"message"]
                                        subtitle:[json objectForKey:@"subtitle"]
                                            type:TSMessageNotificationTypeError];
        }
        [self pullGame:NO];
    }];
    [client enqueueHTTPRequestOperation:missionVote];
}

- (void) teamVote:(int) vote {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    
    NSDictionary *params = @{@"game_id": [NSNumber numberWithInt:self.game.game_id],
                             @"vote":[NSNumber numberWithInt:vote]};
    NSString *path = [NSString stringWithFormat:@"game/%d/team_vote", self.game.game_id];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    AFJSONRequestOperation *teamVote = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[json objectForKey:@"message"]
                                        subtitle:[json objectForKey:@"subtitle"]
                                            type:TSMessageNotificationTypeSuccess];
        }
        if ([json objectForKey:@"changed"]) {
            self.team = [[NSMutableArray alloc] init];
        }
        [self pullGame:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[json objectForKey:@"message"]
                                        subtitle:[json objectForKey:@"subtitle"]
                                            type:TSMessageNotificationTypeError];
        }
        [self pullGame:NO];
    }];
    [client enqueueHTTPRequestOperation:teamVote];
}

- (BOOL) validateTeam {
    return ([self.team count] == [[[self.game currentRound] missionPlayerCount] intValue]);
}

- (void) submitTeam {
    NSMutableArray *player_ids = [[NSMutableArray alloc] init];
    for (Player *p in self.team) {
        [player_ids addObject:p.player_id];
    }
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    
    NSDictionary *params = @{@"game_id": [NSNumber numberWithInt:self.game.game_id],
                             @"player_ids":player_ids};
    
    NSString *path = [NSString stringWithFormat:@"game/%d/submit_team", self.game.game_id];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    AFJSONRequestOperation *submitTeam = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[json objectForKey:@"message"]
                                        subtitle:[json objectForKey:@"subtitle"]
                                            type:TSMessageNotificationTypeSuccess];
        }
        [self pullGame:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[json objectForKey:@"message"]
                                        subtitle:[json objectForKey:@"subtitle"]
                                            type:TSMessageNotificationTypeError];
        }
        [self pullGame:NO];
    }];
    [client enqueueHTTPRequestOperation:submitTeam];
}

- (void) submitLady {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    NSDictionary *params = @{@"chosen_player_id": self.lady.player_id};
    
    NSString *path = [NSString stringWithFormat:@"game/%d/lady_of_the_lake", self.game.game_id];
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    AFJSONRequestOperation *submitLady = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            UIAlertView *ladyAlert = [[UIAlertView alloc] initWithTitle:[json objectForKey:@"message"]
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [ladyAlert show];
        }
        [self pullGame:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        if ([json objectForKey:@"message"]) {
            [TSMessage showNotificationWithTitle:[json objectForKey:@"message"]
                                        subtitle:[json objectForKey:@"subtitle"]
                                            type:TSMessageNotificationTypeSuccess];
        }
        [self pullGame:NO];
    }];
    [client enqueueHTTPRequestOperation:submitLady];
}

#pragma mark - Team Selection Delegate Methods

- (void)togglePlayer:(Player *)player {
    if ([self.team containsObject:player]) {
        [self.team removeObject:player];
        [[self.playerCircleView playerViewForPlayer:player] removeTeamIcon];
    } else {
        [self.team addObject:player];
        [[self.playerCircleView playerViewForPlayer:player] addTeamIcon];
    }
}

- (BOOL) playerIsInTeam:(Player *)player {
    return [self.team containsObject:player];
}

#pragma mark - Lady Selection Delegate Methods

- (void) toggleLady:(Player *)player {
    if (self.lady != nil && [self.lady.user isEqual:player.user]) {
        self.lady = nil;
    } else {
        self.lady = player;
    }
}

- (BOOL) ladySelected:(Player *)player {
    return [self.lady.user isEqual:player.user];
}

@end
