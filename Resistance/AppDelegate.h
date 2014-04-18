//
//  AppDelegate.h
//  Resistance
//
//  Created by Varun Rau on 12/21/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

#import "GamesViewController.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) User *user;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) GamesViewController *gameVC;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) KeychainItemWrapper *keychain;

- (void)checkCredWithSuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success fail:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))fail email:(NSString *)email andPassword:(NSString *)password;
- (void) clearCredentials;
- (BOOL) loggedIn;
- (void) validateUser;

@end
