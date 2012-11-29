//
//  ETWAnnotationView.h
//  BiblioPhile
//
//  Created by mac on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
 
@interface ETWAnnotationView : MKPinAnnotationView <MKReverseGeocoderDelegate> {

    BOOL                   isMoving;
    CGPoint                startLocation;
    CGPoint                originalCenter;

    MKMapView   *map;
	MKPlacemark *_placemark;
}

- (void)changeCoordinate:(CLLocationCoordinate2D)coordinate;

@property (assign,nonatomic) MKMapView* map;

@end
