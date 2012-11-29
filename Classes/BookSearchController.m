//
//  BookSearchController.m
//  BiblioPhile
//
//  Created by mac on 7/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookSearchGenericController.h"
#import "BookSearchController.h"

@implementation BookSearchController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
		
	BookSearchGenericController *classicChoice = 
	    [[BookSearchGenericController alloc] initWithTabBar:@"Classic"];
	
	BookSearchGenericController *neoChoice = 
	    [[BookSearchGenericController alloc] initWithTabBar:@"Neo"];
	
	[tabBarItems addObject:classicChoice];
	[tabBarItems addObject:neoChoice];

	self.viewControllers = tabBarItems;
		
    [super viewDidLoad];
	
	[tabBarItems release];
	[classicChoice release];
	[neoChoice release];
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
    [super dealloc];
}


@end
