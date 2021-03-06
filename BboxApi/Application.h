//
//  Application.h
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Application is an object representation of an application on the Bbox.
 */
@interface Application : NSObject

/**
 Enumeration of the various possible application state.
 */
typedef NS_ENUM(NSInteger, ApplicationStateType) {
    FOREGROUND,
    BACKGROUND,
    STOPPED,
    UNKNOW_STATE
};

/**
 appName of the application. It is not necessarly unique.
 */
@property NSString* appName;

/**
 url of the application logo
 */
@property NSString* logoUrl;

/**
 appId of the application. Null if the application is not started.
 */
@property NSString* appId;

/**
 packageName of the android application on the Bbox. It's unique.
 */
@property NSString* packageName;

/**
 State of the application. You should update it with Application notification.
 */
@property ApplicationStateType state;

/**
 Init an Application object
 @param appName The application name
 @param appId The application ID
 @param packageName the application packageName
 @param logoUrl url of the application logo
 @param state the application state
 @return An instance of an Application object
 */

- (id) init:(NSString *)appName :(NSString *)appId :(NSString *)packageName :(NSString *)logoUrl :(ApplicationStateType)state;



@end
