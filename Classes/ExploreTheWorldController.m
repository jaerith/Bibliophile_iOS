//
//  ExploreTheWorldController.m
//  BiblioPhile
//
//  Created by mac on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "ExploreTheWorldController.h"
#import "ETWMapView.h"
#import "ETWAnnotationView.h"
#import "ETWSearchResultsController.h"

@implementation ExploreTheWorldController

@synthesize mapView;
@synthesize searchButton;
@synthesize searchType;
@synthesize searchRange;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	/*
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	*/
	
	if (self = [super initWithNibName:@"ExploreTheWorld" bundle:[NSBundle mainBundle]]) {
		// Custom initialization
	}	
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	mapView.showsUserLocation=TRUE;
	mapView.mapType=MKMapTypeHybrid;
	mapView.delegate=self;
	
	//Region and Zoom
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.5;
	span.longitudeDelta=0.5;
	
	CLLocationCoordinate2D location=mapView.userLocation.coordinate;
	
	location.latitude=[delegate.currLatitude floatValue];
	location.longitude=[delegate.currLongitude floatValue];;
	region.span=span;
	region.center=location;
		
	//Geocoder Stuff
	
	geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:location];
	geoCoder.delegate=self;
	[geoCoder start];
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
	// Warning
	NSString *warningMsg = 
        [NSString stringWithFormat:@"Center on an interesting location and then hit the search button to bring results.  (NOTE: In order for the GoogleMap controller to work properly, you must have an iPhone or be near an open Wi-Fi port.  If nothing is presented initially, pinch and unpinch to access cached map data."];
	
	UIAlertView *alert = 
	    [[UIAlertView alloc] initWithTitle:@"Info" 
			message:warningMsg delegate:nil 
			    cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	
	[alert show];
	[alert release];	
			
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	
	[mapView release];
	
	[searchButton release];
	[searchType release];
	
    [super dealloc];
}

- (IBAction) search {
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	ETWSearchResultsController *etwSearchResultsController =
	    [[[ETWSearchResultsController alloc] init] autorelease];
	
	float  fSearchRange     = searchRange.value;
	double dCenterLatitude  = mapView.centerCoordinate.latitude;
	double dCenterLongitude = mapView.centerCoordinate.longitude;
	
	NSNumber *currSearchRange = [[NSNumber alloc] initWithFloat:fSearchRange];
	NSNumber *centerLatitude  = [[NSNumber alloc] initWithDouble:dCenterLatitude];
	NSNumber *centerLongitude = [[NSNumber alloc] initWithDouble:dCenterLongitude];
	
	etwSearchResultsController.currSearchType = [searchType titleForSegmentAtIndex:[searchType selectedSegmentIndex]];
	etwSearchResultsController.currRadius     = currSearchRange;
	etwSearchResultsController.currLatitude   = centerLatitude;
	etwSearchResultsController.currLongitude  = centerLongitude;
	
	[delegate.navController pushViewController:etwSearchResultsController animated:YES];
}

#pragma mark -
#pragma mark Reverse Geocoder Handlers
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	NSLog(@"Reverse Geocoder Errored");
	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"Reverse Geocoder completed");
	mPlacemark=placemark;
	[mapView addAnnotation:placemark];
}

#pragma mark -
#pragma mark MapView Handlers
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	
	ETWAnnotationView *annView=[[ETWAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.map = self.mapView;
	annView.animatesDrop=TRUE;
	return annView;
}

#pragma mark -
#pragma mark Touch Handlers
/*
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {

	if ([mapView.annotations count] > 0) {
		[mapView removeAnnotations:mapView.annotations];
	}
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
	CLLocationCoordinate2D location=mapView.userLocation.coordinate;
	
	location.latitude=40.814849;
	location.longitude=-73.622732;
	region.span=span;
	region.center=location;

	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];	
}
*/

@end
