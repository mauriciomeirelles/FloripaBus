//
//  FLBDetailViewController.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/8/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBManager.h"

@interface FLBDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FLBRoute *route;

@property (weak, nonatomic) IBOutlet UICollectionView *departureCollectionView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedDepartureDay;
@property (weak, nonatomic) IBOutlet UILabel *lblRouteName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actvIndicator;
@property (weak, nonatomic) IBOutlet UITableView *streetsTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblDepartures;
@property (weak, nonatomic) IBOutlet UIView *viewDeparturesLine;
@end
