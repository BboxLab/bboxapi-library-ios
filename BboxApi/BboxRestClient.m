//
//  BboxRestClient.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import "BboxRestClient.h"
#import "Constants.h"
@implementation BboxRestClient

@synthesize ip;

@synthesize baseUrl;
@synthesize manager;

- (id)init:(NSString *)initialIp {
    self.ip = initialIp;
    self.baseUrl = [NSString stringWithFormat:@"%@%@%@", @"http://", ip, API_URL];
    [self initManager];
    return self;
}

- (void) initManager {
    NSURL *baseNSURL = [NSURL URLWithString:self.baseUrl];
    self.manager = [AFHTTPSessionManager manager];
    self.manager = [self.manager initWithBaseURL:baseNSURL];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = 7;
    self.manager.securityPolicy.allowInvalidCertificates = YES;
    
    //NSLog(@"%@ %@", self.baseUrl,  self.manager.baseURL);
}


- (void) get:(NSString *)url withParams:(NSDictionary *)params withHeader:(NSDictionary *)header thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    for (NSString* key  in header) {
        id value = [header objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) operation.response;
        callback(false, response.statusCode, nil, error);
    }];
}

- (void) get:(NSString *)url withParams:(NSDictionary *)params thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) operation.response;
        callback(false, response.statusCode, nil, error);
    }];
}


- (void) post:(NSString *)url withBody:(NSDictionary *)body withHeader:(NSDictionary *)header thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    
    for (NSString* key  in header) {
        id value = [header objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager POST:url parameters:body progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) operation.response;
        callback(false, response.statusCode, nil, error);
    }];
}


- (void) post:(NSString *)url withBody:(NSDictionary *)body thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    [manager POST:url parameters:body progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) operation.response;
        callback(false, response.statusCode, nil, error);
    }];
}
- (void) put:(NSString *)url withBody:(NSDictionary *)body  withHeader:(NSDictionary *)header thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    for (NSString* key  in header) {
        id value = [header objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager PUT:url parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(false, response.statusCode, nil, error);
    }];
}

- (void) put:(NSString *)url withBody:(NSDictionary *)body thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    [manager PUT:url parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(false, response.statusCode, nil, error);
    }];
}

- (void) del:(NSString *)url withParams:(NSDictionary *)params  withHeader:(NSDictionary *)header thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    for (NSString* key  in header) {
        id value = [header objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(false, response.statusCode, nil, error);
    }];
}

- (void) del:(NSString *)url withParams:(NSDictionary *)params thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(false, response.statusCode, nil, error);
    }];
}


- (void)post:(NSString *)url withBody:(NSDictionary *)body  withHeader:(NSDictionary *)header thenCallWithHeaders:(void (^)(BOOL, NSInteger, NSDictionary *, id, NSError *))callback {
    for (NSString* key  in header) {
        id value = [header objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    [manager POST:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, [response allHeaderFields], responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(false, response.statusCode, [response allHeaderFields], nil, error);
    }];
}


- (void)post:(NSString *)url withBody:(NSDictionary *)body thenCallWithHeaders:(void (^)(BOOL, NSInteger, NSDictionary *, id, NSError *))callback {
    //NSString * urlRequest = [NSString stringWithFormat:@"%@%@", self.baseUrl, url];
    
    //NSLog(@"%@ %@ %@", self.baseUrl, url, self.manager.baseURL);
    
    [manager POST:url parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(true, response.statusCode, [response allHeaderFields], responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        callback(false, response.statusCode, [response allHeaderFields], nil, error);
    }];
}

@end
