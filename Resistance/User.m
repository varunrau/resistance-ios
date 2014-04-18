//
//  User.m
//  Resistance
//
//  Created by Varun Rau on 12/24/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username;
@synthesize email;
@synthesize auth_token;

- (id) initWithUserName:(NSString *)name {
    if (self) {
        self.username = name;
    }
    return self;
}

- (BOOL) isEqual:(id)object {
    if ([object class] != [User class]) {
        return NO;
    }
    User *otherUser = (User *)object;
    return [[otherUser email] isEqualToString:self.email];
}



+ (RKObjectMapping *)mapping {
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[self class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                        @"name": @"username",
                                                        @"email": @"email"
                                                        }];
    return userMapping;
}

+ (RKResponseDescriptor *)descriptor {
    RKResponseDescriptor *desc = [RKResponseDescriptor responseDescriptorWithMapping:User.mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"user" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return desc;
}

@end
