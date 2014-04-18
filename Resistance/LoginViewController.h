//
//  LoginViewController.h
//  Resistance
//
//  Created by Varun Rau on 12/23/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

#import "KeychainItemWrapper.h"
#import "User.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UITextField *emailField;
@property (nonatomic, assign) IBOutlet UITextField *passwordField;

@property (nonatomic) KeychainItemWrapper *keychain;

- (NSDictionary *)credentials;
- (void) clearCredentials;

@end
