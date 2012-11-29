//
//  ExploreTheWorldController.h
//  BiblioPhile
//
//  Created by mac on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ExploreTheWorldController : UIViewController <MKReverseGeocoderDelegate,MKMapViewDelegate> {

	MKMapView          *mapView;	
	UIButton           *searchButton;
	UISegmentedControl *searchType;
	UISlider           *searchRange;
	
	MKReverseGeocoder *geoCoder;
	MKPlacemark       *mPlacemark;
}

- (IBAction) search;

@property (nonatomic, retain) IBOutlet MKMapView          *mapView;
@property (nonatomic, retain) IBOutlet UIButton           *searchButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *searchType;
@property (nonatomic, retain) IBOutlet UISlider           *searchRange;

@end
