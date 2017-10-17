//
//  RemoteManager.h
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BboxRestClient.h"

/**
 The RemoteManager object allow you to emulate a remote.
 @warning Only the volume methods are working with current version of BboxAPI.
 */
@interface RemoteManager : NSObject

/**
 The BboxRestClient is making all the REST call to the API.
 */
@property BboxRestClient * client;

/**
 Init a RemoteManager with the BboxRestClient provided.
 
 @param client The BboxRestClient of the corresponding Bbox.
 
 @return the newly created RemoteManager
 */
- (id) init:(BboxRestClient*) client;

@end
