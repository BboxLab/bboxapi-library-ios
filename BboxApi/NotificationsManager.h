//
//  NotificationsManager.h
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import "BboxRestClient.h"


@protocol WSDelegate;

@protocol WSDelegate
@optional
-(void)didReceiveMessage:(NSDictionary*) message;
-(void)socketDidOpen;
-(void)socketDidClose;
@end

/**
 The NotificationsManager is a SocketRocket abstraction to establish a websocket connection with the BboxAPI
 */
@interface NotificationsManager : NSObject <SRWebSocketDelegate>

/**
 Our current channelId
 */
@property NSString * channelId;

/**
 An array of callback to call when a notification occur.
 */
//@property NSMutableArray * callbackArray;

/**
 Init a NotificationsManager
 @param restClient BboxRestClient of the bbox we want to open a websocket.
 @param appId The appId of our current application (Obtained with the ApplicationsManager)
 @return an instance of NotificationsManager
 */
- (id) init:(BboxRestClient *)restClient andAppId:(NSString *)appId;

/**
 Open the websocket connection.
 */
- (void) connect:(id<WSDelegate>) delegate;

/**
 Unsubscribe to a resource.
 @param notification Resource you want to unsubscribe ex: 'Application'
 @param callback Result of the operation
 */
- (void) unsubscribe:(NSString *)notification thenCall:(void (^)(BOOL success, NSError * error))callback;

/**
 Update to a resource
 @param notification Resource you want to subscribe to ex: 'Application'
 @param callback Result of the operation
 */
- (void) update:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback;

/**
 Subscribe to a resource
 @param notification Resource you want to subscribe to ex: 'Application'
 @param callback Result of the operation
 */
- (void) subscribe:(NSString *)notification thenCall:(void (^)(BOOL success, NSError * error))callback;

/**
 Send a message to a channelId
 @param message Message you want to send
 @param channelId ChannelId of the receiver
 */
- (void) send:(NSString *)message toChannelId:(NSString *)channelId;

/**
 Send a message to a room
 @param message Message you want to send
 @param room Room to send the message
 */
- (void) send:(NSString *)message toRoom:(NSString *)room;
    
- (void) removeWSDelegate:(id<WSDelegate>) delegate;

@end
