//
//  FLBManager.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "FLBRoute.h"

#define ROUTES_KEY @"routes"

@interface FLBManager : NSObject

////////////////////////////////////////////////////////////////////////////////
/// @name Manager
////////////////////////////////////////////////////////////////////////////////

/**
 * @return A FLBManager shared instance
 */
+ (FLBManager *)singleton;



/**
 Get all routes that have this stop name
 
 @param stopName The stop name to look for routes
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes one argument: a FLBRoutes array.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: the error message.
 */
- (void)getRoutesWithStopName: (NSString *) stopName
                      success:(void (^)(NSArray *routes))success
                        error:(void (^)(NSString *errorMsg)) error;


@end
