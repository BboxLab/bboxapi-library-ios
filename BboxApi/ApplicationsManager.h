//
//  ApplicationsManager.h
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BboxRestClient.h"
#import "Application.h"

/**
 The ApplicationsManager allow to easily manage all the applications on the Bbox.
 */
@interface ApplicationsManager : NSObject

/**
 Init the BboxRestClient with the bbox ip.
 */
@property BboxRestClient* client;

/**
 Init the ApplicationsManager with a BboxRestClient
 @return an instance of ApplicationsManager
 */
- (id) init:(BboxRestClient*)bboxRestClient;

/**
 Get all the applications installed on the Bbox.
 @param callback You will get the reponse in it.
 */
- (void) getApplications:(void (^)(BOOL success, NSMutableArray *applications, NSError *error))callback;

/**
 Get a specific application with a packageName.
 @param name packageName of the application you want
 @param callback You will get the reponse in it.
 */
- (void) getApplication:(NSString*)name :(void (^)(BOOL success, Application *application, NSError *error))callback;

/**
 Start the application with the provided packageName. Add a callback to know if there is an error.
 @param name The application package name you want to start
 @callback callback Call after the request is done and indicate if the operation is a success
 */
- (void) startApplication:(NSString *)name :(void (^)(BOOL success, NSError *error))callback;

- (void) launchIntent:(NSString *)intent :(void (^)(BOOL, NSError *))callback;

@end
