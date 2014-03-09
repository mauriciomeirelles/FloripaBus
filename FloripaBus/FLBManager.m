//
//  FLBManager.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBManager.h"

#define BASE_URL @"https://dashboard.appglu.com/v1/queries/"

#define GET_ROUTES @"findRoutesByStopName/run"
#define GET_STOPS @"findStopsByRouteId/run"
#define GET_DEPARTURES @"findDeparturesByRouteId/run"

@implementation FLBManager

#pragma mark Shared Instance

+ (FLBManager *)singleton {
    static FLBManager *instance;
    
    if (instance == nil)
        instance = [[FLBManager alloc] init];
    
    return instance;
}

#pragma mark AFNetworking methods

-(AFHTTPRequestOperationManager *)AFManagerObject
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"WKD4N7YMA1uiM8V" password:@"DtdTtzMLQlA0hk2C1Yi5pLyVIlAQ68"];
    [manager.requestSerializer setValue:@"staging" forHTTPHeaderField:@"X-AppGlu-Environment"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:(NSJSONReadingAllowFragments)];
    
    return manager;
}


#pragma mark Get Routes

- (void)getRoutesWithStopName:(NSString *) stopName
            success:(void (^)(NSArray *routes))success
            error:(void (^)(NSString *errorMsg)) error
{
    
    [[self AFManagerObject] POST:GET_ROUTES
       parameters:@{@"params" : @{ @"stopName":    [NSString stringWithFormat:@"%%%@%%",[stopName lowercaseString]]} }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *routesRows = responseObject[@"rows"];
              NSMutableArray *routes = [[NSMutableArray alloc] initWithCapacity:routesRows.count];
              
              for(NSDictionary *dicRoute in routesRows)
              {
                  FLBRoute *route = [[FLBRoute alloc] initWithAttrs:dicRoute];
                  [routes addObject:route];
              }
              
              NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
              [currentDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject: routes] forKey:ROUTES_KEY];
              [currentDefaults synchronize];
              
              success(routes);
            
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *err) {
              error(err.description);
          }
     ];
    
}


#pragma mark Get Stops

- (void)getStopsForRoute:(FLBRoute *) route
                      success:(void (^)(NSArray *stops))success
                        error:(void (^)(NSString *errorMsg)) error
{
    
    [[self AFManagerObject] POST:GET_STOPS
                      parameters:@{@"params" : @{ @"routeId": [NSString stringWithFormat:@"%d", route.routeId]} }
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             NSArray *stopsRows = responseObject[@"rows"];
                             NSMutableArray *stops = [[NSMutableArray alloc] initWithCapacity:stopsRows.count];
                             
                             for(NSDictionary *dicStop in stopsRows)
                             {
                                 FLBStop *stop = [[FLBStop alloc] initWithAttrs:dicStop];
                                 [stops addObject:stop];
                             }
                             
                             success(stops);
                            
                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *err) {
                             error(err.description);
                         }
     ];
    
}


#pragma mark Get Departures

- (void)getDeparturesForRoute:(FLBRoute *) route
                 success:(void (^)(NSArray *stops))success
                   error:(void (^)(NSString *errorMsg)) error
{
    
    [[self AFManagerObject] POST:GET_DEPARTURES
                      parameters:@{@"params" : @{ @"routeId": [NSString stringWithFormat:@"%d", route.routeId]} }
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             NSArray *departsRows = responseObject[@"rows"];
                             NSMutableArray *departures = [[NSMutableArray alloc] initWithCapacity:departsRows.count];
                             
                             for(NSDictionary *depDic in departsRows)
                             {
                                 FLBDeparture *departure = [[FLBDeparture alloc] initWithAttrs:depDic];
                                 [departures addObject:departure];
                             }
                             
                             success(departures);
                             
                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *err) {
                             error(err.description);
                         }
     ];
    
}


@end
