//
//  LocationMenuController.m
//  BiblioPhile
//
//  Created by mac on 6/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "LocationMenuController.h"
#import "AllBookLocationsController.h"
#import "BooksByCurrentLocationController.h"

@implementation LocationMenuController

@synthesize list;
@synthesize mapRegionToFile;

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
	
	list = [[NSMutableArray alloc] init];
	mapRegionToFile = [[NSMutableDictionary alloc] init];
		
	[list addObject:@"Near Current Location"];
	[list addObject:@"In U.S. (Atlantic-N.)"];
	[list addObject:@"In U.S. (Atlantic-S.)"];
	[list addObject:@"In U.S. (Central)"];
	[list addObject:@"In U.S. (Mountain)"];
	[list addObject:@"In U.S. (Pacific)"];
	[list addObject:@"In Africa"];
	[list addObject:@"In Asia"];
	[list addObject:@"In Australia"];
	[list addObject:@"In Europe (East)"];
	[list addObject:@"In Europe (West)"];
	[list addObject:@"In Middle East"];
	[list addObject:@"In South America"];
	[list addObject:@"Other"];
	
	[mapRegionToFile setValue:@"BBL_US_Atlantic_North" forKey:@"In U.S. (Atlantic-N.)"];
	[mapRegionToFile setValue:@"BBL_US_Atlantic_South" forKey:@"In U.S. (Atlantic-S.)"];
	[mapRegionToFile setValue:@"BBL_US_Central" forKey:@"In U.S. (Central)"];
	[mapRegionToFile setValue:@"BBL_US_Mountain" forKey:@"In U.S. (Mountain)"];
	[mapRegionToFile setValue:@"BBL_US_Pacific" forKey:@"In U.S. (Pacific)"];
	[mapRegionToFile setValue:@"BBL_Africa" forKey:@"In Africa"];
	[mapRegionToFile setValue:@"BBL_Asia" forKey:@"In Asia"];
	[mapRegionToFile setValue:@"BBL_Australia" forKey:@"In Australia"];
	[mapRegionToFile setValue:@"BBL_Europe_East" forKey:@"In Europe (East)"];
	[mapRegionToFile setValue:@"BBL_Europe_West" forKey:@"In Europe (West)"];
	[mapRegionToFile setValue:@"BBL_Middle_East" forKey:@"In Middle East"];
	[mapRegionToFile setValue:@"BBL_South_America" forKey:@"In South America"];	
	[mapRegionToFile setValue:@"BBL_Other" forKey:@"Other"];

	booksbyCurrLocController = [[BooksByCurrentLocationController alloc] init];
	// allBookLocationsController
	
	// Warning
	NSString *warningMsg = 
	    [NSString stringWithFormat:@"In order for the 'Find Near Current Location' option to work properly, you must have an iPhone or be near an open Wi-Fi port."];
	
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
	[booksbyCurrLocController release];
	[list release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger) tableView:(UITableView*)tableView
  numberOfRowsInSection:(NSInteger)section {
	
	return [list count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView
		 cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	
	static NSString* LocMenuCellIdentifier = @"LocationMenuCellIdentifier";
	
	UITableViewCell *cell = 
	    [tableView dequeueReusableCellWithIdentifier:LocMenuCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:LocMenuCellIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];
	
	cell.text = rowString;
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (UITableViewCellAccessoryType) tableView:(UITableView*)tableView
		  accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath{
	
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void) tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	NSUInteger row = [indexPath row];
	NSString* selected = [list objectAtIndex:row];
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	if (row == 0) {
		
		NSString *currLocationTitle;
		
		if (delegate.currLocation != nil) {
			currLocationTitle = delegate.currLocationDesc;

		    /*
			[NSString stringWithFormat:@"(%+.6f°,%+.6f°)", 
				currLocation.coordinate.latitude, currLocation.coordinate.longitude];
		    */
		}
		else {
		}
		
		booksbyCurrLocController.title = currLocationTitle;
		[delegate.navController pushViewController:booksbyCurrLocController animated:YES];
	}
	else {
		AllBookLocationsController *allBookLocationsController =
		    [[[AllBookLocationsController alloc] init] autorelease];
		
		allBookLocationsController.title = selected;
		allBookLocationsController.targetFile = [mapRegionToFile valueForKey:selected];
		[delegate.navController pushViewController:allBookLocationsController animated:YES];
	}
}

@end
