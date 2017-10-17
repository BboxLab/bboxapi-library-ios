//
//  Application.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import "Application.h"
@implementation Application

@synthesize appId;
@synthesize appName;
@synthesize packageName;
@synthesize logoUrl;
@synthesize state;

- (id) init:(NSString *)appName :(NSString *)appId :(NSString *)packageName :(NSString *)logoUrl :(ApplicationStateType)state {
    self.appName = appName;
    self.appId = appId;
    self.logoUrl = logoUrl;
    self.state = state;
    self.packageName = packageName;
    return self;
}

@end
