//
//  GIBLSelectionController.m
//  BiblioPhile
//
//  Created by mac on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "GIBLSelectionController.h"

@implementation GIBLSelectionController

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
		
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	NSInteger tmpIndex        = 0;
	NSString* prevFirstLetter = nil;
	
	NSArray *unsortedGameSelection = [delegate.gamesInspiredByBooks allKeys]; 
	
	NSArray *gameSelection = [unsortedGameSelection sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	// NOTE : Assemble list from book collection
	for (id key in gameSelection) {
		
		NSString* tmpGame = key;		
				
		NSArray *tmpGameVals = [delegate.gamesInspiredByBooks valueForKey:tmpGame];
			
		NSString* studio = [tmpGameVals objectAtIndex:0];
		NSString* book   = [tmpGameVals objectAtIndex:1];
		NSString* author = [tmpGameVals objectAtIndex:2]; 
			
		NSString* GameEntry = 
			[NSString stringWithFormat:@"%@ by %@|%@ by %@", 
				tmpGame, studio, book, author];
			
		[self.list addObject:GameEntry];

		tmpIndex = tmpIndex + 1;
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
	
	static NSString* GIBLByBookCellIdentifier = @"GIBLByBookCellIdentifier";
	
	UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:GIBLByBookCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:GIBLByBookCellIdentifier] autorelease];
	}
	else {
		UILabel *topLabel = [cell.contentView.subviews objectAtIndex:0];
		UILabel *bottomLabel = [cell.contentView.subviews objectAtIndex:1];
		
		[topLabel removeFromSuperview];
		[bottomLabel removeFromSuperview];
	}	
	
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];
	
	NSArray *rowData = [rowString componentsSeparatedByString:@"|"];
	
	NSString* gameField = [rowData objectAtIndex:0];
	NSString* bookField = [rowData objectAtIndex:1];
	
	CGRect gameRect = CGRectMake(5.0, 0.0, 240, 50);
	UILabel *gameView = [[UILabel alloc] initWithFrame:gameRect];
	gameView.text = gameField;
	gameView.numberOfLines = 2;
	gameView.textColor = [UIColor blackColor];
	gameView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:gameView];
	
	CGRect bookRect = CGRectMake(5.0, 51.0, 240, 50);
	UILabel *bookView = [[UILabel alloc] initWithFrame:bookRect];
	bookView.text = bookField;
	bookView.numberOfLines = 2;
	bookView.textColor = [UIColor grayColor];
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
	
	return 100;	 
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
