//
//  GamesViewController.m
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "GamesViewController.h"
#import "GameViewController.h"
#import "NewGameViewController.h"
#import "PlayViewController.h"
#import "AppDelegate.h"

@interface GamesViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *loginButton;

@end

@implementation GamesViewController

@synthesize games;
@synthesize loginButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    self.title = @"Games";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    loginButton.title = ([delegate loggedIn]) ? @"Logout" : @"Login";
    [self pullGames];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.games objectAtIndex:[indexPath row]] name];
    return cell;
}


#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Game *game = [self.games objectAtIndex:indexPath.row];
    if ([game userInGame:[(AppDelegate *) [[UIApplication sharedApplication] delegate] user]]) {
        [self performSegueWithIdentifier:@"playGame" sender:self];
        NSLog(@"play game");
    } else {
        NSLog(@"game info");
        [self performSegueWithIdentifier:@"gameInfo" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Game *game = [self.games objectAtIndex:(NSUInteger)[[self.tableView indexPathForCell:sender] row]];
    if ([[segue identifier] isEqualToString:@"gameInfo"]) {
        GameViewController *destinationVC = (GameViewController *)[segue destinationViewController];
        [destinationVC setGame:game];
    } else if ([[segue identifier] isEqualToString:@"playGame"]) {
        PlayViewController *destinationVC = (PlayViewController *)[segue destinationViewController];
        [destinationVC setGame:game];
    }
}

- (void)refreshTable: (UIRefreshControl *)refreshControl {
    [refreshControl beginRefreshing];
    [self pullGames];
    NSLog(@"refreshing table");
}

- (void) pullGames {
    NSLog(@"refreshing");
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil
                                                                               method:RKRequestMethodGET
                                                                                 path:@"game"
                                                                           parameters:nil];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[Game.descriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        [self.refreshControl endRefreshing];
        [self setGames:[result.dictionary objectForKey:@"games"]];
        [self.tableView reloadData];
        NSLog(@"Pulled successfully game data");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        NSLog(@"Error pulling game data");
    }];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (IBAction)presentActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Create new game"
                                                    otherButtonTitles:@"Log Out", nil];
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Create new game
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        NewGameViewController *newGameVC = [storyboard instantiateViewControllerWithIdentifier:@"NewGameVC"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newGameVC];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        // Log out
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate clearCredentials];
    }
}

- (IBAction)login:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate loggedIn]) {
        [delegate clearCredentials];
    } else {
        [self presentViewController:delegate.loginVC animated:YES completion:nil];
    }
}

@end
