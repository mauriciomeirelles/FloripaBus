//
//  FLBDetailViewController.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBDetailViewController.h"

@interface FLBDetailViewController ()
{
    NSArray *stops;
    NSArray *weekdayDepartures;
    NSArray *saturdayDepartures;
    NSArray *sundayDepartures;
    
    int serverCount;
}

@end

@implementation FLBDetailViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    stops = weekdayDepartures = saturdayDepartures = sundayDepartures = [[NSArray alloc] init];
    
    
    [self loadData];

}

#pragma mark - Load from server

-(void)loadData
{
    
    serverCount = 0;
    
    //Get Stops
    [[FLBManager singleton] getStopsForRoute:_route
                                      success:^(NSArray *stopsAux) {
                                          
                                          stops = stopsAux;
                                          
                                          [self performSelectorOnMainThread:@selector(updateUI)
                                                                 withObject:nil
                                                              waitUntilDone:NO];
                                      } error:^(NSString *errorMsg) {
                                          [self performSelectorOnMainThread:@selector(showErrorAlterWithMessage:)
                                                                 withObject:errorMsg
                                                              waitUntilDone:NO];
                                      }];
    
    //Get Departures
    [[FLBManager singleton] getDeparturesForRoute:_route
                                     success:^(NSArray *departuresAux) {
                                         
                                         //Get Weekdays
                                         NSPredicate *weekdayPredicate = [NSPredicate predicateWithFormat:@"calendar = 'WEEKDAY'"];
                                         weekdayDepartures = [departuresAux filteredArrayUsingPredicate:weekdayPredicate];
                                         
                                         //Get Saturday
                                         NSPredicate *saturdayPredicate = [NSPredicate predicateWithFormat:@"calendar = 'SATURDAY'"];
                                         saturdayDepartures = [departuresAux filteredArrayUsingPredicate:saturdayPredicate];
                                         
                                         //Get Sunday
                                         NSPredicate *sundayPredicate = [NSPredicate predicateWithFormat:@"calendar = 'SUNDAY'"];
                                         sundayDepartures = [departuresAux filteredArrayUsingPredicate:sundayPredicate];
                                         
                                         [self performSelectorOnMainThread:@selector(updateUI)
                                                                withObject:nil
                                                             waitUntilDone:NO];
                                     } error:^(NSString *errorMsg) {
                                         [self performSelectorOnMainThread:@selector(showErrorAlterWithMessage:)
                                                                withObject:errorMsg
                                                             waitUntilDone:NO];
                                     }];
}

#pragma mark - Update UI



-(void)updateUI
{
    //If both requests already back from server update the screen
    if(serverCount > 0)
    {
        [self.departureCollectionView reloadData];
        
        CGFloat newHeight = (45*ceil(weekdayDepartures.count/4));
                
        self.departureCollectionView.frame = CGRectMake(self.departureCollectionView.frame.origin.x, self.departureCollectionView.frame.origin.y, self.departureCollectionView.frame.size.width,newHeight );
        
        self.scrollView.contentSize = CGSizeMake(320, newHeight + 30);
        
    }
    else
    {
        serverCount++;
    }
    
}

#pragma mark - Alert View

-(void)showErrorAlterWithMessage: (NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return weekdayDepartures.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.departureCollectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *lblTime = (UILabel *)[cell viewWithTag:10];
    
    FLBDeparture *departure = (FLBDeparture *)weekdayDepartures[indexPath.row];
    
    lblTime.text = departure.time;
    
    
    return cell;
    
}


@end
