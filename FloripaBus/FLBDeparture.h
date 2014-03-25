//
//  FLBDeparture.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBBaseModel.h"

@interface FLBDeparture : FLBBaseModel

- (NSString *) calendar;
- (NSInteger) departureId;
- (NSString *) time;

@end
