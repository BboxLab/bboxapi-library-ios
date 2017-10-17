//
//  BboxManager.m
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#include <arpa/inet.h>

#import "BboxManager.h"
#import "Bbox.h"

#import "Constants.h"
@implementation BboxManager

@synthesize callback;


NSMutableArray * resolvers;

NSNetServiceBrowser *serviceBrowser;
NSNetService *serviceResolver;

- (void) startLooking:(void (^)(Bbox *))initialCallback {
    if (serviceBrowser) {
        [serviceBrowser stop];
    }
    
    resolvers = [[NSMutableArray alloc] init];
    
    self.callback = initialCallback;
    
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    serviceBrowser.delegate = self;
    [serviceBrowser searchForServicesOfType:MDNS_TYPE inDomain:MDNS_DOMAIN];
}

- (void) stopLooking {
    if (serviceBrowser) {
        [serviceBrowser stop];
    }
}

#pragma mark NSNetserviceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    //if ([[aNetService name] isEqualToString:BBoxIp]) {
        aNetService.delegate = self;
        [aNetService resolveWithTimeout:0.0];
        [resolvers addObject:aNetService];
    //}
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    for (NSData* data in [service addresses]) {
        //NSLog(@"Found %@ %@ %@", [service domain], [service hostName], [service name]);
        char addressBuffer[100];
        struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
        int sockFamily = socketAddress->sin_family;
        if (sockFamily == AF_INET) {
            const char* addressStr = inet_ntop(sockFamily,
                                               &(socketAddress->sin_addr), addressBuffer,
                                               sizeof(addressBuffer));            
            if (addressStr) {
                NSString * adr = [[NSString alloc] initWithUTF8String:addressStr];
                Bbox *bbox = [[Bbox alloc]initWithIp:adr name:[service name]];
                
                self.callback(bbox);
            }
        }
    }
}

@end
