//
//  FLBStop.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBBaseModel.h"

@interface FLBStop : FLBBaseModel

- (NSInteger) stopId;
- (NSString *) name;
- (NSInteger) routeId;
- (NSInteger) sequence;

@end
