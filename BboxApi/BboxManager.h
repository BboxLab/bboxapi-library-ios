//
//  BboxManager.h
//  BboxApi
//
//  Created by Aiman on 16/10/2017.
//  Copyright © 2017 Bouygues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bbox.h"

/**
 ‘BboxManager‘ is a class made to help find Bbox on the LAN. It use mDNS protocol.
 */
@interface BboxManager : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate>

/**
 A callback called when a bbox is found. it return a BSSBbox object.
 */
@property (nonatomic, copy) void (^callback)(Bbox *);

/**
 Method to start looking for bbox on LAN. Call the provided callback for every Bbox found.
 */
- (void) startLooking:(void (^)(Bbox * bbox))callback;


/**
 Method to stop looking
 */
- (void) stopLooking;

@end
