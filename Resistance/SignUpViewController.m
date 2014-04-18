//
//  SignUpViewController.m
//  Resistance
//
//  Created by Varun Rau on 12/25/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"

@interface SignUpViewController () {
    NSString *email;
    NSString *password;
}

@end

@implementation SignUpViewController

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

- (BOOL) textFieldShouldReturn: (UITextField *)textField {
    UIResponder *nextResponder = [textField.superview viewWithTag:textField.tag + 1];
    if (nextResponder)
        [nextResponder becomeFirstResponder];
    else {
        [textField resignFirstResponder];
        email = self.emailField.text;
        password = self.passwordField.text;
        [self.keychain setObject:email forKey:(__bridge id)kSecAttrAccount];
        [self.keychain setObject:password forKey:(__bridge id)kSecValueData];
        [self postUserCredentialsWithSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } andFail:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString *errorMessage = [self parseErrorMessage:(NSDictionary *)JSON];
            UIAlertView *signUpFailed = [[UIAlertView alloc] initWithTitle:@"Sign Up Failed" message:errorMessage delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
            [signUpFailed show];
        }];
    }
    return NO;
}

- (NSString *) parseErrorMessage:(NSDictionary *)json {
    NSString *message = @"";
    // TODO
    return message;
}

- (void)postUserCredentialsWithSuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success andFail:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))fail {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    
    NSDictionary *params = @{@"user":@{@"email":email, @"password":password}};
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"users" parameters:params];
    
    AFJSONRequestOperation *postCred = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(request, response, JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        fail(request, response, error, JSON);
    }];
    
    [client enqueueHTTPRequestOperation:postCred];
}

@end
