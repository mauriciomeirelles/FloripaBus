//
//  FLBMapViewController.h
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/9/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FLBMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *stopName;

@end
