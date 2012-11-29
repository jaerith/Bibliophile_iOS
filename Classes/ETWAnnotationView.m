//
//  ETWAnnotationView.m
//  BiblioPhile
//
//  Created by mac on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ETWAnnotationView.h"

@implementation ETWAnnotationView

@synthesize map;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Touch Handlers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // The view is configured for single touches only.
    UITouch* aTouch = [touches anyObject];
    startLocation = [aTouch locationInView:[self superview]];
    originalCenter = self.center;
	
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* aTouch = [touches anyObject];
    CGPoint newLocation = [aTouch locationInView:[self superview]];
    CGPoint newCenter;
	
    // If the user's finger moved more than 5 pixels, begin the drag.
    if ( (abs(newLocation.x - startLocation.x) > 2.0) ||
		(abs(newLocation.y - startLocation.y) > 2.0) ) {
		isMoving = YES;
	}
	
    // If dragging has begun, adjust the position of the view.
    if (isMoving)
    {
        newCenter.x = originalCenter.x + (newLocation.x - startLocation.x);
        newCenter.y = originalCenter.y + (newLocation.y - startLocation.y);
        self.center = newCenter;
    }
    else {    // Let the parent class handle it.
        [super touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoving)
    {
        // Update the map coordinate to reflect the new position.
        CGPoint newCenter = self.center;
		
        CLLocationCoordinate2D newCoordinate = 
			[map convertPoint:newCenter toCoordinateFromView:self.superview];

        [self changeCoordinate:newCoordinate];
		
        // Clean up the state information.
        startLocation = CGPointZero;
        originalCenter = CGPointZero;
        isMoving = NO;
    }
    else
        [super touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Change coordinate

- (void)changeCoordinate:(CLLocationCoordinate2D)coordinate {
	
	// Try to reverse geocode here
	MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];	
}

#pragma mark -
#pragma mark MKReverseGeocoderDelegate methods

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	
	_placemark = placemark;
	
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"MKAnnotationCalloutInfoDidChangeNotification" object:self]];

	[geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	_placemark = nil;
	[geocoder release];
}

@end
