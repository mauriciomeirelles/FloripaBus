//
//  FLBDetailViewController.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBDetailViewController.h"

typedef enum {
    WEEKDAY  = 0,
    SATURDAY = 1,
    SUNDAY   = 2
} DEPATURE_DAYS;


@interface FLBDetailViewController ()
{
    NSArray *stops;
    NSArray *weekdayDepartures;
    NSArray *saturdayDepartures;
    NSArray *sundayDepartures;
    
    NSArray *departureCollectionArrayAux;
    
    int serverCount;
}

@end

@implementation FLBDetailViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    departureCollectionArrayAux = stops = weekdayDepartures = saturdayDepartures = sundayDepartures = [[NSArray alloc] init];
    
    _lblRouteName.text = _route.longName;
    
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
                                         
                                         departureCollectionArrayAux = weekdayDepartures;
                                         
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


-(void)fixCollectionViewAndScrollViewHeight
{
    //Fix TableView height
    CGFloat newHeight = 44*stops.count;
    self.streetsTableView.frame = CGRectMake(self.streetsTableView.frame.origin.x,
                                             self.streetsTableView.frame.origin.y,
                                             self.streetsTableView.frame.size.width,
                                             newHeight);
    
    //Change Segmented Control position
    _segmentedDepartureDay.frame = CGRectMake(_segmentedDepartureDay.frame.origin.x,
                                              self.streetsTableView.frame.origin.y + newHeight + 40,
                                              _segmentedDepartureDay.frame.size.width,
                                              _segmentedDepartureDay.frame.size.height);
    
    //Fix CollectionView position and height
    
    newHeight = (45*ceil(departureCollectionArrayAux.count/4));
    
    self.departureCollectionView.frame = CGRectMake(self.departureCollectionView.frame.origin.x,
                                                    _segmentedDepartureDay.frame.origin.y + _segmentedDepartureDay.frame.size.height + 10,
                                                    self.departureCollectionView.frame.size.width,newHeight );
    
    self.scrollView.contentSize = CGSizeMake(320, self.departureCollectionView.frame.origin.y + newHeight + 30);
}

-(void)updateUI
{
    //If both requests already back from server update the screen
    if(serverCount > 0)
    {
        [_actvIndicator stopAnimating];
        
        [_scrollView setHidden:NO];
        
        [self.departureCollectionView reloadData];
        [self.streetsTableView reloadData];
        
        [self fixCollectionViewAndScrollViewHeight];
        
        if(saturdayDepartures.count == 0)
            [_segmentedDepartureDay setEnabled:NO forSegmentAtIndex:SATURDAY];
        if(sundayDepartures.count == 0)
            [_segmentedDepartureDay setEnabled:NO forSegmentAtIndex:SUNDAY];
        
    }
    else
    {
        serverCount++;
    }
    
}

#pragma mark - Alert View

-(void)showErrorAlterWithMessage: (NSString *)message
{
    [_actvIndicator stopAnimating];

    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}


#pragma mark - UICollectionView Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return departureCollectionArrayAux.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [self.departureCollectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *lblTime = (UILabel *)[cell viewWithTag:10];
    
    FLBDeparture *departure = (FLBDeparture *)departureCollectionArrayAux[indexPath.row];
    
    lblTime.text = departure.time;
    
    
    return cell;
    
}

#pragma mark - Segmented Method

- (IBAction)segmentedDepartureClicked:(id)sender {
    
    switch (_segmentedDepartureDay.selectedSegmentIndex) {
        case WEEKDAY:
            departureCollectionArrayAux = weekdayDepartures;
            break;
        case SATURDAY:
            departureCollectionArrayAux = saturdayDepartures;
            break;
        case SUNDAY:
            departureCollectionArrayAux = sundayDepartures;
            break;
            
        default:
            departureCollectionArrayAux = weekdayDepartures;
            break;
    }
    
    [_departureCollectionView reloadData];
    
    [self fixCollectionViewAndScrollViewHeight];

}


#pragma mark - UITableViewDataSource && UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stops.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.streetsTableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblStopName = (UILabel *)[cell viewWithTag:10];
    
    FLBStop *stopObj = (FLBStop *)stops[indexPath.row];
    lblStopName.text = stopObj.name;
    
    return cell;
}


@end
