//
//  Bbox.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import "Bbox.h"

@implementation Bbox

//@synthesize remoteManager;
@synthesize connectManager;
@synthesize applicationsManager;
@synthesize bboxRestClient;
@synthesize notificationsManager;
@synthesize ip;

- (id)initWithIp:(NSString *)initialIp name:(NSString *)name  {
    
    self.ip = initialIp;
    self.name = name;
    
    self.bboxRestClient = [[BboxRestClient alloc] init:self.ip];
    self.connectManager = [[ConnectManager alloc] init:self.bboxRestClient];
//    self.remoteManager = [[RemoteManager alloc] initWithBboxRestClient:self.bboxRestClient];
    self.applicationsManager = [[ApplicationsManager alloc] init:self.bboxRestClient];
    return self;
}

@end
