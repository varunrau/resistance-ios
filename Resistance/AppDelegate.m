//
//  AppDelegate.m
//  Resistance
//
//  Created by Varun Rau on 12/21/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"

@implementation AppDelegate

@synthesize loginVC;
@synthesize gameVC;
@synthesize nav;
@synthesize keychain;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainID" accessGroup:nil];
    [self.keychain setObject:@"Resistance" forKey:(__bridge id)kSecAttrService];
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://localhost:3000/api"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [RKObjectManager setSharedManager:manager];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [storyboard instantiateInitialViewController];
    self.gameVC = [storyboard instantiateViewControllerWithIdentifier:@"gamesVC"];
    self.loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (!self.nav.presentedViewController) {
        [self validateUser];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void) validateUser {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    NSDictionary *params = [self.loginVC credentials];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"sessions" parameters:params];
    AFJSONRequestOperation *cred = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *json = (NSDictionary *)JSON;
        self.user = nil;
        User *user = [[User alloc] init];
        user.email = [json objectForKey:@"email"];
        user.auth_token = [json objectForKey:@"auth_token"];
        self.user = user;
        [[[RKObjectManager sharedManager] defaultHeaders] setValue:user.auth_token forKey:@"auth_token"];
        [[[RKObjectManager sharedManager] defaultHeaders] setValue:user.email forKey:@"email"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"keychain does not have valid user info");
    }];
    [client enqueueHTTPRequestOperation:cred];
}

- (void) clearCredentials {
    [self.keychain setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [self.keychain setObject:@"" forKey:(__bridge id)kSecValueData];
    self.user = nil;
    [[[RKObjectManager sharedManager] defaultHeaders] setValue:@"" forKey:@"auth_token"];
    [[[RKObjectManager sharedManager] defaultHeaders] setValue:@"" forKey:@"email"];
}

- (BOOL) loggedIn {
    return self.user != nil;
}
- (void)checkCredWithSuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success fail:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))fail email:(NSString *)email andPassword:(NSString *)password {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    AFHTTPClient *client = [manager HTTPClient];
    
    NSDictionary *params = @{@"email":email, @"password":password};
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"sessions" parameters:params];
    
    AFJSONRequestOperation *checkCred = [AFJSONRequestOperation JSONRequestOperationWithRequest: request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(request, response, JSON);
        NSDictionary *json = (NSDictionary *)JSON;
        self.user = nil;
        User *user = [[User alloc] init];
        user.email = [json objectForKey:@"email"];
        user.auth_token = [json objectForKey:@"auth_token"];
        self.user = user;
        [[[RKObjectManager sharedManager] defaultHeaders] setValue:user.auth_token forKey:@"auth_token"];
        [[[RKObjectManager sharedManager] defaultHeaders] setValue:user.email forKey:@"email"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        fail(request, response, error, JSON);
    }];
    
    [client enqueueHTTPRequestOperation:checkCred];
}

@end
