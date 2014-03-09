//
//  FLBMapViewController.m
//  FloripaBus
//
//  Created by Mauricio Meirelles on 3/9/14.
//  Copyright (c) 2014 Mauricio. All rights reserved.
//

#import "FLBMapViewController.h"

@interface FLBMapViewController ()
{
    MKPointAnnotation *annotationStop;
}

@end

@implementation FLBMapViewController

#pragma mark - View life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-27.594988, -48.548174), 3400, 3400);
    [_mapView setRegion:region animated:YES];
}

#pragma mark - Long Press

- (IBAction)mapLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    
    if(annotationStop)
    {
        [self.mapView removeAnnotation:annotationStop];
        annotationStop = nil;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    

    
    CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:pinLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *stopStreet = [placemarks objectAtIndex:0];
            
            annotationStop = [[MKPointAnnotation alloc] init];
            annotationStop.coordinate = touchMapCoordinate;
            annotationStop.title = stopStreet.thoroughfare;
            [self performSelectorOnMainThread:@selector(showCallout) withObject:nil waitUntilDone:YES];
        }
        else {
            annotationStop = [[MKPointAnnotation alloc] init];
            annotationStop.coordinate = touchMapCoordinate;
            annotationStop.title = @"";
            [self.mapView addAnnotation:annotationStop];
            [[self.mapView viewForAnnotation:annotationStop] setCanShowCallout:NO];
        }
    }];
    
   
}


-(void)showCallout
{
    [self.mapView addAnnotation:annotationStop];
    [[self.mapView viewForAnnotation:annotationStop] setCanShowCallout:YES];
    [[self.mapView viewForAnnotation:annotationStop] setSelected:YES animated:YES];

}

#pragma mark - Back to Modal

- (IBAction)cancelModal:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.stopName = annotationStop.title;
}

@end
