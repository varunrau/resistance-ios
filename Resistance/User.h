//
//  User.h
//  Resistance
//
//  Created by Varun Rau on 12/24/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *auth_token;

- (id) initWithUserName:(NSString *)name;

- (BOOL) isEqual:(id)object;

+ (RKObjectMapping *)mapping;
+ (RKResponseDescriptor *) descriptor;

@end
