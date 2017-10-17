//
//  Bbox.h
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RemoteManager.h"
#import "ApplicationsManager.h"
#import "BboxRestClient.h"
#import "NotificationsManager.h"
#import "ConnectManager.h"
/**
 Object representation of a Bbox.
 */
@interface Bbox : NSObject

/**
 RemoteManager for the current Bbox
 */
//@property RemoteManager * remoteManager;
/**
 RemoteManager for the current Bbox
 */
@property ConnectManager * connectManager;

/**
 ApplicationsManager for the current Bbox
 */
@property ApplicationsManager * applicationsManager;

/**
 BboxRestClient for the current Bbox
 */
@property BboxRestClient * bboxRestClient;

/**
 NotificationsManager for the current Bbox
 @warning You have to instanciate it when you need it.
 */
@property NotificationsManager * notificationsManager;

/**
 ip of the current box
 */
@property NSString * ip;

/**
 name of the current box
 */
@property NSString * name;

/**
 Init a Bbox object with the provided ip and name. It will instanciate a BboxRestClient, RemoteManager, and ApplicationsManager
 */
- (id)initWithIp:(NSString *)initialIp name:(NSString *)name;

@end
