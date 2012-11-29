//
//  ETWMapView.m
//  BiblioPhile
//
//  Created by mac on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "ETWMapView.h"

@implementation ETWMapView

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

/*
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
*/

@end
