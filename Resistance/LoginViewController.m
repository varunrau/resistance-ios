//
//  LoginViewController.m
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController () {
    NSString *email;
    NSString *password;
}

@end

@implementation LoginViewController

@synthesize emailField;
@synthesize passwordField;

@synthesize keychain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Login";
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.keychain = [delegate keychain];
    
    if ([delegate loggedIn]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (NSDictionary *)credentials {
    self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainID" accessGroup:nil];
    email = [self.keychain objectForKey:(__bridge id)kSecAttrAccount];
    password = [self.keychain objectForKey:(__bridge id)kSecValueData];
    
    NSDictionary *params = @{@"email":email, @"password":password};
    return params;
}

- (void) login {
    [self.keychain setObject:email forKey:(__bridge id)kSecAttrAccount];
    [self.keychain setObject:password forKey:(__bridge id)kSecValueData];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate checkCredWithSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        [self verifiedCred:json];
    } fail:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        [self unverifiedCred:json];
    } email:email andPassword:password];
}

- (void) clearCredentials {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate clearCredentials];
}

- (BOOL) textFieldShouldReturn: (UITextField *)textField {
    UIResponder *nextResponder = [textField.superview viewWithTag:textField.tag + 1];
    if (nextResponder)
        [nextResponder becomeFirstResponder];
    else {
        [textField resignFirstResponder];
        email = self.emailField.text;
        password = self.passwordField.text;
        [self login];
    }
    return NO;
}

- (void) verifiedCred:(NSDictionary *)json {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *user = [[User alloc] init];
    user.email = [json objectForKey:@"email"];
    user.auth_token = [json objectForKey:@"auth_token"];
    appDelegate.user = user;
    [[[RKObjectManager sharedManager] defaultHeaders] setValue:user.auth_token forKey:@"auth_token"];
    [[[RKObjectManager sharedManager] defaultHeaders] setValue:user.email forKey:@"email"];
    [self clearTextFields];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) unverifiedCred:(NSDictionary *)json {
    NSLog(@"LOGIN FAILED");
    UIAlertView *loginFailedAlert = [[UIAlertView alloc] initWithTitle:@"Login Attempt Failed" message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
    [loginFailedAlert show];
    [self clearTextFields];
}

- (void) clearTextFields {
    self.passwordField.text = @"";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"segue identififer = %@",segue.identifier);
}

@end
