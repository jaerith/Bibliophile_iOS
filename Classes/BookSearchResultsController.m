//
//  BookSearchResultsController.m
//  BiblioPhile
//
//  Created by mac on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "BookSearchResultsController.h"

@implementation BookSearchResultsController

@synthesize searchResults;
@synthesize list;

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

- (void) retrieveData {
	
	if (self.list == nil) {
		self.list = [[NSMutableArray alloc] init];
	}
	
	// Now find the songs in this library that are in the Inspired list	
	BiblioPhileAppDelegate *delegate = 
		(BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	NSArray *unsortedBookSelection = [self.searchResults allKeys];
	
	NSArray *bookSelection = [unsortedBookSelection sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	// NOTE : Assemble list from book collection
	for (id key in bookSelection) {
		
		NSString* tmpBook = key;
		NSString* author = [self.searchResults valueForKey:tmpBook];

		NSString* ByBookEntry = [NSString stringWithFormat:@"%@ by %@", tmpBook, author];
				
		[self.list addObject:ByBookEntry];
	}	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self retrieveData];
		
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
	[searchResults release];
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
	
	static NSString* BookSearchResultsCellIdentifier = @"BookSearchResultsCellIdentifier";
	
	UITableViewCell *cell = 
	    [tableView dequeueReusableCellWithIdentifier:BookSearchResultsCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:BookSearchResultsCellIdentifier] autorelease];
	}
	else {
		UILabel *topLabel = [cell.contentView.subviews objectAtIndex:0];
		
		[topLabel removeFromSuperview];
	}
	
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];
				
	CGRect bookRect = CGRectMake(5.0, 0.0, 240, 50);
	UILabel *bookView = [[UILabel alloc] initWithFrame:bookRect];
	bookView.text = rowString;
	bookView.numberOfLines = 2;
	bookView.textColor = [UIColor blackColor];
	bookView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:bookView];	
	
	// [bookView release];
	// [songView release];
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (CGFloat) tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	return 50;	 
}

- (UITableViewCellAccessoryType) tableView:(UITableView*)tableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath{
	
	// return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryNone;
}

- (void) tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	/*	 
	 NSUInteger row = [indexPath row];
	 NSString* selected = [list objectAtIndex:row];
	 
	 BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	 
	 if (row == kByBook) {
	 siblByBookController.title = selected;
	 [delegate.navController pushViewController:siblByBookController animated:YES];
	 }
	 else {
	 siblByPerformerController.title = selected;
	 [delegate.navController pushViewController:siblByPerformerController animated:YES];
	 }
	 */
}

@end
