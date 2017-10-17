//
//  BSSConnectManager.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//


#import "ConnectManager.h"
#import "Constants.h"

@implementation ConnectManager


- (id) init:(BboxRestClient *)client {
    self.client = client;
    return self;
}

- (void) getToken:(NSString *)appId :(NSString *)appSecret :(void (^)(BOOL, NSError *))callback {
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    
    [body setObject:appId forKey:AppId_Key];
    [body setObject:appSecret forKey:AppSecret_Key];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:URL_Token parameters:body progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *headerData = [response allHeaderFields];
        
        if ([headerData objectForKey:Token_Header_Key] != nil){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[headerData objectForKey:Token_Header_Key] forKey:Token_userDefaults_Key];
            [userDefaults synchronize];
        }
        callback(1, 0);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        callback(0, error);
    }];
}


- (void) getSession:(void (^)(BOOL success, NSError * error))callback {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    
    [body setObject:[userDefaults objectForKey:Token_userDefaults_Key] forKey:Token_Key];
    
    [_client post:URL_Session withBody:body thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[headers objectForKey:SessionId_Header_Key] forKey:Session_userDefaults_Key];
            
            [userDefaults synchronize];
        }
        callback(success, error);
    }];
}


@end

