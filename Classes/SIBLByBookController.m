//
//  SIBLByBookController.m
//  BiblioPhile
//
//  Created by mac on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "SIBLByBookController.h"

@implementation SIBLByBookController

@synthesize list;
@synthesize	keys;
@synthesize bookIndex;
@synthesize sectionCounts;

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
	
	if (self.keys == nil) {
		self.keys = [[NSMutableArray alloc] init];
	}
	
	if (self.bookIndex == nil) {
		self.bookIndex = [[NSMutableDictionary alloc] init];
	}
	
	if (self.sectionCounts == nil) {
		self.sectionCounts = [[NSMutableArray alloc] init];
	}			
	
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

	NSInteger tmpIndex        = 0;
	NSInteger tmpSectionCount = 0;
	NSString* prevFirstLetter = nil;
	
	NSArray *unsortedBookSelection = [delegate.songsByBook allKeys]; 
	
	NSArray *bookSelection = [unsortedBookSelection sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
		
	// NOTE : Assemble list from book collection
	for (id key in bookSelection) {
		
		NSString* tmpBook = key;		
		
		NSDictionary* tmpBookMappings = [delegate.songsByBook valueForKey:tmpBook];

		for (id songkey in tmpBookMappings) {
	
			NSString *tmpSong = songkey;
			
			NSArray *tmpBookSongVals = [tmpBookMappings valueForKey:tmpSong];
		
			NSString* author    = [tmpBookSongVals objectAtIndex:0];
			NSString* performer = [tmpBookSongVals objectAtIndex:2]; 
			
			NSString* ByBookEntry = 
				[NSString stringWithFormat:@"%@ by %@|%@ by %@", 
					tmpBook, author, tmpSong, performer];
			
		    [self.list addObject:ByBookEntry];
			
			if ([tmpBook length] > 0) {
				
				NSString* firstLetter = [tmpBook substringToIndex:1];
				
				if ([bookIndex valueForKey:firstLetter] == nil) {
					NSNumber *tmpNumber = [[NSNumber alloc] initWithInteger:tmpIndex];
					[bookIndex setValue:tmpNumber forKey:firstLetter];
				}
				
				if (tmpIndex > 4) {
					if ([firstLetter isEqualToString:prevFirstLetter]) {
						tmpSectionCount = tmpSectionCount + 1;
					}
					else {
						NSNumber *tmpNumber = [[NSNumber alloc] initWithInteger:tmpSectionCount];
						[sectionCounts addObject:tmpNumber];
						tmpSectionCount = 0;
					}
					
					prevFirstLetter = firstLetter;
				}
			}
		}
		
		tmpIndex = tmpIndex + 1;
	}
	
	// NOTE : Finish off the section counts
	NSNumber *tmpNumber = [[NSNumber alloc] initWithInteger:tmpSectionCount];
    [sectionCounts addObject:tmpNumber];
	
	// NOTE : Create index here
	[keys addObject:@"A"];
	[keys addObject:@"B"];
	[keys addObject:@"C"];
	[keys addObject:@"D"];
	[keys addObject:@"E"];
	[keys addObject:@"F"];
	[keys addObject:@"G"];
	[keys addObject:@"H"];
	[keys addObject:@"I"];
	[keys addObject:@"J"];
	[keys addObject:@"K"];
	[keys addObject:@"L"];
	[keys addObject:@"M"];
	[keys addObject:@"N"];
	[keys addObject:@"O"];
	[keys addObject:@"P"];
	[keys addObject:@"Q"];
	[keys addObject:@"R"];
	[keys addObject:@"S"];
	[keys addObject:@"T"];
	[keys addObject:@"U"];
	[keys addObject:@"V"];
	[keys addObject:@"W"];
	[keys addObject:@"X"];
	[keys addObject:@"Y"];
	[keys addObject:@"Z"];
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

/*
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
	
	return [sectionCounts count];
}
 
- (NSInteger) tableView:(UITableView*)tableView
  numberOfRowsInSection:(NSInteger)section {
	
	NSNumber *tmpNumber = [sectionCounts objectAtIndex:section];
	return [tmpNumber integerValue];
}
*/

- (UITableViewCell*) tableView:(UITableView*)tableView
		 cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	
	static NSString* SIBLByBookCellIdentifier = @"SIBLByBookCellIdentifier";
	
	UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:SIBLByBookCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:SIBLByBookCellIdentifier] autorelease];
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
	NSString* songField = [rowData objectAtIndex:1];
	
	CGRect bookRect = CGRectMake(5.0, 0.0, 240, 50);
	UILabel *bookView = [[UILabel alloc] initWithFrame:bookRect];
	bookView.text = bookField;
	bookView.numberOfLines = 2;
	bookView.textColor = [UIColor blackColor];
	bookView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:bookView];

	CGRect songRect = CGRectMake(5.0, 51.0, 240, 50);
	UILabel *songView = [[UILabel alloc] initWithFrame:songRect];
	songView.text = songField;
	songView.numberOfLines = 2;
	songView.textColor = [UIColor grayColor];
	songView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:songView];	
	
	// [bookView release];
	// [songView release];
		
	return cell;
}

/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

	if ([bookIndex valueForKey:title] != nil) {
		NSInteger tmpNumber = [[bookIndex valueForKey:title] integerValue];
		return tmpNumber;
	}
	else{
		return 0;
	}
}

- (NSString*) tableView:(UITableView*)tableView
	titleForHeaderInSection:(NSInteger)section{
	
	NSString *key = [keys objectAtIndex:section];
	return key;
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
