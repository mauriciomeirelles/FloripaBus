//
//  FLBDeparture.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBDeparture.h"

@implementation FLBDeparture

- (NSString *) calendar
{
    return [self returnNSString:attrs[@"calendar"]];
}

- (NSInteger) departureId
{
    return [self returnNSInteger:attrs[@"id"]];
}

- (NSString *) time
{
    return [self returnNSString:attrs[@"time"]];
}

@end
