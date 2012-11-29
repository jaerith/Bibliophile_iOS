//
//  AllBookLocationsController.m
//  BiblioPhile
//
//  Created by mac on 6/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "AllBookLocationsController.h"

@implementation AllBookLocationsController

@synthesize list;
@synthesize targetFile;

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

	/*
	BiblioPhileAppDelegate *delegate = 
		(BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	*/
	
	int rowCount = 0;
	
	NSString* selectedLocationFile = [[NSBundle mainBundle] pathForResource:targetFile ofType:@"plist"];
	
	NSLog(selectedLocationFile);

	NSDictionary *LocationBooksData = [NSDictionary dictionaryWithContentsOfFile:selectedLocationFile];
	
	NSArray *titleKeys = [LocationBooksData allKeys];
	
	for (id titleKey in titleKeys) {
		
		NSString *tmpTitle = titleKey;
		
		NSArray *tmpBookData = [LocationBooksData valueForKey:tmpTitle];
		
		NSString* author   = [tmpBookData objectAtIndex:0];
		NSString* location = [tmpBookData objectAtIndex:1];

		NSString* ByLocationEntry = 
		    [NSString stringWithFormat:@"%@ by %@|%@", 
		        tmpTitle, author, location];
		
		[self.list addObject:ByLocationEntry];
		
		rowCount = rowCount + 1;
		
		// To trim enumeration for performance purposes
		if (rowCount > 1000) {
			break;
		}
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
	[targetFile release];
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
	
	static NSString* AllLocationBooksCellIdentifier = @"AllLocationBooksCellIdentifier";
	
	UITableViewCell *cell = 
	    [tableView dequeueReusableCellWithIdentifier:AllLocationBooksCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:AllLocationBooksCellIdentifier] autorelease];
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
	
	NSString* bookField = [rowData objectAtIndex:0];
	NSString* locationField = [rowData objectAtIndex:1];
	
	CGRect bookRect = CGRectMake(5.0, 0.0, 240, 50);
	UILabel *bookView = [[UILabel alloc] initWithFrame:bookRect];
	bookView.text = bookField;
	bookView.numberOfLines = 2;
	bookView.textColor = [UIColor blackColor];
	bookView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:bookView];
	
	CGRect locationRect = CGRectMake(5.0, 51.0, 240, 50);
	UILabel *locationView = [[UILabel alloc] initWithFrame:locationRect];
	locationView.text = locationField;
	locationView.numberOfLines = 2;
	locationView.textColor = [UIColor grayColor];
	locationView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:locationView];	
	
	// [bookView release];
	// [songView release];
	
	return cell;
}

/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	return 1;
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView*)tableView {
	
	return keys;
}
*/

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
