//
//  NewGameViewController.m
//  Resistance
//
//  Created by Varun Rau on 12/26/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "NewGameViewController.h"

#import <RestKit/RestKit.h>

@interface NewGameViewController ()

@end

@implementation NewGameViewController

@synthesize nameField;
@synthesize numPlayersPicker;

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
	// Do any additional setup after loading the view.
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d players", row + 5];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (IBAction)createGame:(id)sender {
    NSString *name = self.nameField.text;
    int numPlayersPrim = [self.numPlayersPicker selectedRowInComponent:0] + 5;
    NSNumber *numPlayers = [[NSNumber alloc] initWithInt:numPlayersPrim];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    
    NSDictionary *params = @{@"name": name, @"num_players":numPlayers};
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"game" parameters:params];
    AFJSONRequestOperation *postGame = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Game created!");
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Game not created");
    }];
    [client enqueueHTTPRequestOperation:postGame];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
