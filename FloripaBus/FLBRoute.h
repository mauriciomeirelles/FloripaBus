//
//  FLBRoute.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBBaseModel.h"

@interface FLBRoute : FLBBaseModel

- (NSInteger) agencyId;
- (NSInteger) routeId;
- (NSDate *) lastModifiedDate;
- (NSString *) longName;
- (NSInteger) shortName;

@end
