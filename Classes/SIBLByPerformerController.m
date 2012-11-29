//
//  SIBLByPerformerController.m
//  BiblioPhile
//
//  Created by mac on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SIBLByPerformerController.h"
#import "BiblioPhileAppDelegate.h"

@implementation SIBLByPerformerController

@synthesize list;
@synthesize	keys;
@synthesize performerIndex;

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
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	NSArray *unsortedBookSelection = [delegate.songsByPerformer allKeys]; 
	
	NSArray *performerSelection = [unsortedBookSelection sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	// NOTE : Assemble list from book collection
	for (id key in performerSelection) {
		
		NSString* tmpPerformer = key;
		
		NSDictionary* tmpPerformerMappings = [delegate.songsByPerformer valueForKey:tmpPerformer];
		
		for (id songkey in tmpPerformerMappings) {
			
			NSString *tmpSong = songkey;
			
			NSArray *tmpPerformerSongVals = [tmpPerformerMappings valueForKey:tmpSong];
			
			NSString* book   = [tmpPerformerSongVals objectAtIndex:2];
			NSString* author = [tmpPerformerSongVals objectAtIndex:1]; 
			
			NSString* ByPerformerEntry = 
				[NSString stringWithFormat:@"%@ by %@|%@ by %@", 
					tmpSong, tmpPerformer, book, author];
			
		    [self.list addObject:ByPerformerEntry];
		}
	}
	
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

- (UITableViewCell*) tableView:(UITableView*)tableView
		 cellForRowAtIndexPath:(NSIndexPath*)indexPath{
	
	static NSString* SIBLByPerformerCellIdentifier = @"SIBLByPerformerCellIdentifier";

	UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:SIBLByPerformerCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:SIBLByPerformerCellIdentifier] autorelease];
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
	
	NSString* songField = [rowData objectAtIndex:0];
	NSString* bookField = [rowData objectAtIndex:1];
	
	CGRect songRect = CGRectMake(5.0, 0.0, 240, 50);
	UILabel *songView = [[UILabel alloc] initWithFrame:songRect];
	songView.text = songField;
	songView.numberOfLines = 2;
	songView.textColor = [UIColor blackColor];
	songView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:songView];
	
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

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

	return 1;
}

/*
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
