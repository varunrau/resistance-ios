//
//  GameViewController.m
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "GameViewController.h"
#import "PlayViewController.h"
#import "AppDelegate.h"
#import "PlayerView.h"

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize game;
@synthesize joinGameButton;

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
}

- (void) viewDidAppear:(BOOL)animated
{
    [self hideUI];
    [self pullGame];
    [self refreshView];
    [self showUI];
}

- (void) hideUI {
    self.playersTableView.hidden = YES;
    self.gameStatus.hidden = YES;
}

- (void) showUI {
    self.playersTableView.hidden = NO;
    self.gameStatus.hidden = NO;
}

- (void) refreshView {
    self.title = self.game.name;
    [self.playersTableView reloadData];
    self.gameStatus.text = self.game.status;
    User *user = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user];
    self.joinGameButton.title = [self.game userInGame:user] ? @"Leave Game" : @"Join Game";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.game.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.game.players objectAtIndex:[indexPath row]] name];
    return cell;
}


- (void) pullGame {
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
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error pulling game data");
    }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (IBAction)refreshGame:(id)sender {
    [self pullGame];
    [self refreshView];   
}

- (IBAction)joinGame:(id)sender {
    if ([self.game userInGame:[(AppDelegate *)[[UIApplication sharedApplication] delegate] user]]) {
        [self leaveGame];
    } else {
        [self joinGame];
    }
}

- (void) leaveGame {
    NSLog(@"NEED TO IMPLEMENT THIS");
}

- (void)joinGame {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    
    NSDictionary *params = @{@"game_id": [NSNumber numberWithInt:self.game.game_id]};
    
    NSString *path = [NSString stringWithFormat:@"game/%d/join", self.game.game_id];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    AFJSONRequestOperation *joinGame = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Joined Game");
        [self pullGame];
        
        // TODO: Message
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlayViewController *newGameVC = [storyboard instantiateViewControllerWithIdentifier:@"playGameVC"];
        [newGameVC setGame:self.game];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newGameVC];
        //[self presentViewController:nav animated:YES completion:nil];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed to join game");
    }];
    [client enqueueHTTPRequestOperation:joinGame];
}

@end
