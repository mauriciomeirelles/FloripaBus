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
    
    annotationStop = [[MKPointAnnotation alloc] init];
    annotationStop.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annotationStop];

    
    [geocoder reverseGeocodeLocation:pinLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *stopStreet = [placemarks objectAtIndex:0];
            annotationStop.title = stopStreet.thoroughfare;
            [self performSelectorOnMainThread:@selector(showCallout) withObject:nil waitUntilDone:YES];
        }
        else {
            annotationStop.title = @"";
            [self performSelectorOnMainThread:@selector(showCallout) withObject:nil waitUntilDone:YES];
        }
    }];
    
   
}


-(void)showCallout
{
    [self.mapView selectAnnotation:annotationStop animated:YES];
}

#pragma mark - Back to Modal

- (IBAction)cancelModal:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.stopName = annotationStop.title;
}


#pragma mark - MapView Delegate

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"myPin"];

    if(pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myPin"];
    }
 

    pin.animatesDrop = NO;
    pin.draggable = YES;
    pin.canShowCallout = YES;
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:annotationView.annotation.coordinate.latitude longitude:annotationView.annotation.coordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];

        [geocoder reverseGeocodeLocation:pinLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *stopStreet = [placemarks objectAtIndex:0];
                annotationStop.title = stopStreet.thoroughfare;
            }
            else {
                annotationStop.title = @"";
            }
        }];
    }
}


@end
