//
//  RootViewController.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "RootViewController.h"
#import "SecondLevelViewController.h"
#import "BookSelectionController.h"
#import "MyLibraryViewController.h"
#import "FileParser.h"
#import "MagicQuoteBall.h"
#import "SIBLByRefSelector.h"
#import "GIBLSelectionController.h"
#import "LocationMenuController.h"
#import "YCQMPickQuoteController.h"
#import "BookSearchController.h"
#import "ExploreTheWorldController.h"

@implementation RootViewController
@synthesize controllers;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
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
	self.title = @"BiblioPhile";
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	// Book Selection
	BookSelectionController *bookSelectionController = 
	    [[BookSelectionController alloc] initWithStyle:UITableViewStylePlain];
	
	bookSelectionController.title = @"Classic Books";
	bookSelectionController.rowImage = nil;
	
	[array addObject:bookSelectionController];
	[bookSelectionController release];
	
	// Random Quote Generator
	MagicQuoteBall *magicQuoteBall = [[MagicQuoteBall alloc] init];
	
	magicQuoteBall.title = @"Rock-And-Quote!";
	
	[array addObject:magicQuoteBall];
	[magicQuoteBall release];	

	/*
	// My Library
	MyLibraryViewController *myLibraryViewController =
	    [[MyLibraryViewController alloc] initWithStyle:UITableViewStylePlain];
	
	myLibraryViewController.title = @"My Library";
	myLibraryViewController.rowImage = nil;
	
	[array addObject:myLibraryViewController];
	[myLibraryViewController release];
	*/
	
	// Music Data
	SIBLByRefSelector *siblController = 
		[[SIBLByRefSelector alloc] initWithStyle:UITableViewStylePlain];
	
	siblController.title    = @"Songs Inspired by Books";
	siblController.rowImage = nil;
	
	[array addObject:siblController];
	[siblController release];
	
	/*
	// Game Data
	GIBLSelectionController *giblController = 
        [[GIBLSelectionController alloc] initWithStyle:UITableViewStylePlain];
	
	giblController.title    = @"Games Inspired by Books";
	giblController.rowImage = nil;
	
	[array addObject:giblController];
	[giblController release];	
	*/
	
	// Location Data
	LocationMenuController *locMenuController =
		[[LocationMenuController alloc] init];
	
	locMenuController.title    = @"Locations in Books";
	locMenuController.rowImage = nil;
	
	[array addObject:locMenuController];
	[locMenuController release];
	
	/*
	// "You Can Quote Me" option
	YCQMPickQuoteController *ycqmPickQuoteController =
		[[YCQMPickQuoteController alloc] init];
	
	ycqmPickQuoteController.title    = @"You Can Quote Me";
	ycqmPickQuoteController.rowImage = nil;
	
	[array addObject:ycqmPickQuoteController];
	[ycqmPickQuoteController release];
	*/
	
	/*
	// Category Search
	BookSearchController *bookSearchController = [[BookSearchController alloc] init];
	
	bookSearchController.title = @"Category Search";
	
	[array addObject:bookSearchController];
	[bookSearchController release];
	*/
	
	// Explore The World
	ExploreTheWorldController *exploreTheWorldController = 
		[[ExploreTheWorldController alloc] init];
	
	exploreTheWorldController.title = @"Explore the World";
	
	[array addObject:exploreTheWorldController];
	[exploreTheWorldController release];

	// Finishing touches
	self.controllers = array;
	[array release];
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
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[controllers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger) tableView:(UITableView*)tableView
  numberOfRowsInSection:(NSInteger)section {
        return [self.controllers count];	
}

- (UITableViewCell*) tableView:(UITableView*)tableView
		 cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	
	static NSString *RootViewControllerCell = @"RootViewControllerCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RootViewControllerCell];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] 
				    initWithFrame:CGRectZero reuseIdentifier:RootViewControllerCell] autorelease];
	}
	
	// Configure the cell
	NSUInteger row = [indexPath row];
	UIViewController *controller = [controllers objectAtIndex:row];
	
	cell.text = controller.title;
	// cell.image = controller.rowImage;

	return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (UITableViewCellAccessoryType) tableView:(UITableView*)tableView
		  accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void) tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	NSUInteger row = [indexPath row];
	
	if (row == kMagicQuoteBall) {
		
		MagicQuoteBall *nextController = [self.controllers objectAtIndex:row];
		
		BiblioPhileAppDelegate *delegate = 
		    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
		
		[delegate.navController pushViewController:nextController animated:YES];
	}
	/*
	else if (row == CatSearch) {
		
		BookSearchController *nextController = [self.controllers objectAtIndex:row];
		
		BiblioPhileAppDelegate *delegate =
		    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
		
		[delegate.navController pushViewController:nextController animated:YES];
	}
	*/
	else if (row == ExploreTheWorld) {
		
		ExploreTheWorldController *nextController = [self.controllers objectAtIndex:row];
		
		BiblioPhileAppDelegate *delegate = 
		    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
		
		[delegate.navController pushViewController:nextController animated:YES];		
	}
	else {
		
		SecondLevelViewController *nextController = [self.controllers objectAtIndex:row];
	
		BiblioPhileAppDelegate *delegate = 
			(BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
		[delegate.navController pushViewController:nextController animated:YES];
	}
}
@end
