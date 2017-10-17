//
//  BSSConnectManager.h
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//


#import "BboxRestClient.h"
@interface ConnectManager : NSObject

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

- (void) getToken:(NSString *)appId :(NSString *)appSecret :(void (^)(BOOL success, NSError * error))callback;
- (void) getSession:(void (^)(BOOL success, NSError * error))callback;

@end

