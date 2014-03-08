//
//  FLBStop.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBStop.h"

@implementation FLBStop

- (NSInteger) stopId
{
    return [self returnNSInteger:attrs[@"id"]];
}

- (NSString *) name
{
    return [self returnNSString:attrs[@"name"]];
}

- (NSInteger) routeId
{
    return [self returnNSInteger:attrs[@"route_id"]];
}

- (NSInteger) sequence
{
    return [self returnNSInteger:attrs[@"sequence"]];
}

@end
