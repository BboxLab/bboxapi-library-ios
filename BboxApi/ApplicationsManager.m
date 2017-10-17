//
//  ApplicationsManager.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import "ApplicationsManager.h"
#import "Application.h"
#import "Constants.h"

@implementation ApplicationsManager

@synthesize client;

- (id) init:(BboxRestClient *)bboxRestClient {
    self.client = bboxRestClient;
    return self;
}

- (void) getApplications:(void (^)(BOOL, NSMutableArray *, NSError *))callback {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key]  forKey:SessionId_Header_Key];
    
    
    [client get:Applications_Key withParams:nil withHeader:header thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (success) {
            NSArray* res = response;
            NSMutableArray* apps = [[NSMutableArray alloc] init];
            for(NSDictionary* app in res) {
                NSString *appName = [app objectForKey:AppName_Key];
                NSString *logoUrl = [app objectForKey:LogoUrl_Key];
                NSString *packageName = [app objectForKey:PackageName_Key];
                NSString *appId = [app objectForKey:AppId_Key];
                
                ApplicationStateType state;
                if ([[app objectForKey:AppState_Key] isEqual: Foreground_Key]) {
                    state = FOREGROUND;
                } else if ([[app objectForKey:AppState_Key] isEqual: Background_Key]) {
                    state = BACKGROUND;
                } else {
                    state = STOPPED;
                }
                
                Application * newApp = [[Application alloc] init:appName :appId :packageName :logoUrl :state];
                [apps addObject:newApp];
            }
            callback(true, apps, nil);
        } else {
            callback(false, nil, error);
        }
    }];
};

- (void) getApplication:(NSString *)name :(void (^)(BOOL, Application *, NSError *))callback {
    [self getApplications:^(BOOL success, NSMutableArray *applications, NSError *error) {
        if (success) {
            Application * appFound = nil;
            for (Application *app in applications) {
                if ([app.packageName isEqualToString:name]) {
                    appFound = app;
                    break;
                }
            }
            if (appFound != nil) {
                callback(true, appFound, nil);
            } else {
                //TODO créer NSError pour appName qui n'existe pas.
                callback(false, nil, nil);
            }
        } else {
            callback(false, nil, error);
        }
    }];
}

- (void) startApplication:(NSString *)name :(void (^)(BOOL, NSError *))callback {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key] forKey:SessionId_Header_Key];
    
    [client post:[NSString stringWithFormat:@"applications/%@", name] withBody:nil withHeader:header thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (callback != nil) {
            callback(success, error);
        }
    }];
}

- (void) launchIntent:(NSString *)intent :(void (^)(BOOL, NSError *))callback {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key] forKey:SessionId_Header_Key];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    [body setObject:intent forKey:@"intent"];
    
    [client post:@"applications/fr" withBody:body withHeader:header thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (callback != nil) {
            BOOL launched = NO;
            
            if (statusCode == 204) {
                launched = YES;
            }
            
            callback(launched, error);
        }
    }];
}

@end
