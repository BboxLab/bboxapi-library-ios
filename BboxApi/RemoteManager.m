//
//  RemoteManager.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import "RemoteManager.h"
#import "Constants.h"
@implementation RemoteManager


- (id) init:(BboxRestClient *)client {
    self.client = client;
    return self;
}

@end
