//
//  BookSelectionController.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookSelectionController.h"
#import "BookTraitsController.h"
#import "BiblioPhileAppDelegate.h"

@implementation BookSelectionController

@synthesize list;

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
	
	// NOTE : Load data for display
	BiblioPhileAppDelegate *delegate = 
		(BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	NSArray *unsortedBookSelection = [delegate.fileParser.bookData allKeys];
	// NSArray *bookSelection = [delegate.fileParser.bookData keysSortedByValueUsingSelector:@selector(compare:)];
	
	NSArray *bookSelection = [unsortedBookSelection sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	self.list = bookSelection;
	
	// [bookSelection release];
	
	// NOTE : Prepare title and child controller
	BookTraitsController *bookTraitsController = 
	    [[BookTraitsController alloc] initWithStyle:UITableViewStylePlain];
	
	bookTraitsController.title = @"Traits";
	bookTraitsController.rowImage = nil;
	
	childController = bookTraitsController;
	
	// [bookTraitsController release];
	
	// Warning
	NSString *warningMsg = 
	    [NSString stringWithFormat:@"This applet allows you to traverse interesting metadata about books.  Plus, you can forward quotes via email to friends, with a friendly Bibliophile reminder as a footnote."];
	
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
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[list release];
	[childController release];
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
	
	static NSString* BookSelectionCellIdentifier =
		@"BookSelectionCellIdentifier";
	
	UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:BookSelectionCellIdentifier];
		 
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
			reuseIdentifier:BookSelectionCellIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];
	cell.text = rowString;
	
	// [rowString release];
	
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
	
	SecondLevelViewController *nextController = childController;
	
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	delegate.currBookTitle = [self.list objectAtIndex:row];
	
	nextController.title = delegate.currBookTitle;
	
	[delegate.navController pushViewController:nextController animated:YES];
}
	
@end
