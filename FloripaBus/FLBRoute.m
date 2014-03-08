//
//  FLBRoute.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBRoute.h"

@implementation FLBRoute

- (NSInteger) agencyId
{
    return [self returnNSInteger:attrs[@"agencyId"]];

}

- (NSInteger) routeId
{
    return [self returnNSInteger:attrs[@"id"]];
    
}

- (NSDate *) lastModifiedDate
{
    return [self returnNSDateFromTimeInterval:attrs[@"lastModifiedDate"]];
}

- (NSString *) longName
{
    return [self returnNSString:attrs[@"longName"]];
}

- (NSInteger) shortName
{
    return [self returnNSInteger:attrs[@"shortName"]];
    
}


@end
