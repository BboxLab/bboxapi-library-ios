//
//  NotificationsManager.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import "NotificationsManager.h"
#import "Constants.h"
/**
 Private methods for the Websocket delegate
 */

@interface NotificationsManager()

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
@property (strong,nonatomic) NSMutableArray *delegates;

@end


@implementation NotificationsManager

@synthesize channelId;
@synthesize delegates;


BboxRestClient * client;
SRWebSocket * webSocket;
NSString * applicationId;
NSMutableArray * notifications;
NSMutableArray * delegates;

- (id) init:(BboxRestClient *)restClient andAppId:(NSString *)appId {
    
    client = restClient;
    applicationId = appId;
    delegates = [[NSMutableArray alloc] init];
    notifications = [[NSMutableArray alloc] init];
    
    //self.callbackArray = [[NSMutableArray alloc] init];
    return self;
}

- (void)connect:(id<WSDelegate>) delegate {
    [self.delegates addObject:delegate];
    
    if (webSocket != nil
        && [webSocket readyState] == SR_OPEN) {
        [delegate socketDidOpen];
    }
    else {
        webSocket.delegate = nil;
        webSocket = nil;
        NSString *urlString = [NSString stringWithFormat: URL_part, client.ip];
        
        SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
        
        newWebSocket.delegate = self;
        
        [newWebSocket open];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    NSLog(@"Socket OPENED");
    webSocket = newWebSocket;
    [webSocket send:(id)applicationId];
    
    for (id cb in self.delegates) {
        [cb socketDidOpen];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    //[self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"%@", reason);
    //[self connectWebSocket];
    
    for (id cb in self.delegates) {
        [cb socketDidClose];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    //NSLog(@"Message received");
    NSError *e;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: &e];
    
//    for (void (^cb)(NSDictionary *) in self.callbackArray) {
//        cb(JSON);
//        NSLog(@"%@", JSON);
//    }
    
    for (id cb in self.delegates) {
        [cb didReceiveMessage:JSON];
    }
}

- (void) subscribe:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback {
    
    Boolean exist = false;
    
    for (NSString * notif in notifications) {
        if ([notif isEqual:notification]) {
            exist = true;
        }
    }
    
    if (!exist) {
        [notifications addObject:notification];
        //NSLog(@"added");
    }
    
    [self update:^(BOOL success, NSError *error) {
        callback(success, error);
    }];
}



- (void) update:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback {
    
    Boolean exist = false;
    
    for (NSString * notif in notifications) {
        if ([notif isEqual:notification]) {
            exist = true;
        }
    }
    
    if (!exist) {
        [notifications addObject:notification];
        //NSLog(@"added");
    }
    
    [self update:^(BOOL success, NSError *error) {
        callback(success, error);
    }];
    
}

- (void) unsubscribe:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback {
    
    for (NSString * notif in notifications) {
        if ([notif isEqual:notification]) {
            [notifications removeObject:notif];
        }
    }
    
    [self update:^(BOOL success, NSError *error) {
        callback(success, error);
    }];
    
}

- (void) update:(void (^)(BOOL success, NSError * error))callback {
    
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    NSMutableArray * res = [[NSMutableArray alloc] init];
    
    for (NSString * notif in notifications) {
        [res addObject:@{ResourceId:[NSString stringWithFormat:@"Message/%@", notif]}];
        //[res addObject:[NSString stringWithFormat:@"Message/%@", notif]];
    }
    
    [body setObject:applicationId forKey:AppId_Key];
    [body setObject:res forKey:Resources_Key];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key]  forKey:SessionId_Header_Key];
    
    
    [client post:NOTIFICATION withBody:body  withHeader:header  thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSArray * urlArray = [[headers objectForKey:Location_Key] componentsSeparatedByString:@"/"];
            self.channelId = [urlArray objectAtIndex:[urlArray count]-1];
        }
        callback(success, error);
    }];
    
//    [client post:NOTIFICATION withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
//        
//    }];
}


- (void)send:(NSString *)message toChannelId:(NSString *)channelId {
    
    NSMutableDictionary * toSend = [[NSMutableDictionary alloc] init];
    
    [toSend setObject:self.channelId forKey:Destination_Key];
    [toSend setObject:applicationId forKey:Source_Key];
    [toSend setObject:message forKey:Message_Key];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toSend
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [webSocket send:jsonString];
}

- (void)send:(NSString *)message toRoom:(NSString *)room {
    //[self sendThisMessage:message toChannelId:[NSString stringWithFormat:@"Message/%@", room]];
    
    NSMutableDictionary * toSend = [[NSMutableDictionary alloc] init];
    
    [toSend setObject:[NSString stringWithFormat:@"Message/%@", room] forKey:Destination_Key];
    [toSend setObject:applicationId forKey:Source_Key];
    [toSend setObject:message forKey:Message_Key];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toSend
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [webSocket send:jsonString];
}

-(void) removeWSDelegate:(id<WSDelegate>) delegate {
    [self.delegates removeObject:delegate];
}

@end
