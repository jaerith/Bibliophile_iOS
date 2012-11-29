//
//  ETWSearchResultsController.m
//  BiblioPhile
//
//  Created by mac on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "ETWSearchResultsController.h"

@implementation ETWSearchResultsController

@synthesize list;
@synthesize currSearchType;
@synthesize currLatitude;
@synthesize currLongitude;
@synthesize currRadius;

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
	
	// Fill out the list
	NSString *targetFile;
	float fLatitude     = [self.currLatitude floatValue];
	float fLongitude    = [self.currLongitude floatValue];
	float fSearchRadius = [self.currRadius floatValue];

	if ([self.currSearchType isEqualToString:@"Cuisine"]) {
		targetFile = @"CBBL_Sample";
	}
	else if ([self.currSearchType isEqualToString:@"Politics"]) {
		targetFile = @"PBBL_Sample";
	}
	else if ((fLatitude >= 38.8397f && fLatitude <= 59.3555f) && 
		     (fLongitude >= -85.7373f) && (fLongitude <= -50.625f)) {
		
		targetFile = @"BBL_US_Atlantic_North";
	}
	else if ((fLatitude >= 14.5197f && fLatitude <= 38.8397f) && 
			 (fLongitude >= -85.7373f) && (fLongitude <= -50.625f)) {
		
		targetFile = @"BBL_US_Atlantic_South";
	}
	else if ((fLatitude >= 14.9447f && fLatitude <= 59.3555f) && 
		     (fLongitude >= -102.3046f) && (fLongitude <= -85.7374f)) {
		
		targetFile = @"BBL_US_Central";
	}
	else if ((fLatitude >= 14.9447f && fLatitude <= 59.3555f) && 
		     (fLongitude >= -114.0820f) && (fLongitude <= -102.3046f)) {
		
		targetFile = @"BBL_US_Mountain";
	}
	else if ((fLatitude >= 14.9447f && fLatitude <= 59.3555f) && 
		     (fLongitude >= -128.3203f) && (fLongitude <= -114.0821f)) {
		
		targetFile = @"BBL_US_Pacific";
	}
	else if ((fLatitude >= -36.5978f && fLatitude <= 35.1739f) && 
		     (fLongitude >= -17.2266f) && (fLongitude <= 33.4863f)) {
		
		targetFile = @"BBL_US_Africa";
	}
	else if ((fLatitude >= -5.2660f && fLatitude <= 103.7109f) && 
		     (fLongitude >= 62.2266f) && (fLongitude <= 180.0000f)) {
		
		targetFile = @"BBL_Asia";
	}
	else if ((fLatitude >= -43.8345f && fLatitude <= -11.1784f) && 
		     (fLongitude >= 112.1484f) && (fLongitude <= 154.6875f)) {
		
		targetFile = @"BBL_Australia";
	}
	else if ((fLatitude >= 36.7037f && fLatitude <= 71.1878f) && 
			 (fLongitude >= 13.5351f) && (fLongitude <= 38.3203f)) {
		
		targetFile = @"BBL_Europe_East";
	}
	else if ((fLatitude >= 36.7037f && fLatitude <= 71.1878f) && 
			 (fLongitude >= -10.1074f) && (fLongitude <= 13.5351f)) {
		
		targetFile = @"BBL_Europe_West";
	}
	else if ((fLatitude >= 12.6403f && fLatitude <= 47.6367f) && 
		     (fLongitude >= 34.2333f) && (fLongitude <= 60.9301f)) {
		
		targetFile = @"BBL_Middle_East";
	}
	else if ((fLatitude >= -82.9688f && fLatitude <= -34.4531f) && 
		     (fLongitude >= -69.6093f) && (fLongitude <= -55.9737f)) {
		
		targetFile = @"BBL_South_America";
	}
	else {
		targetFile = @"BBL_Other";
	}
	
	int rowCount = 0;
	
	NSString* selectedLocationFile = [[NSBundle mainBundle] pathForResource:targetFile ofType:@"plist"];
	
	NSDictionary *LocationBooksData = [NSDictionary dictionaryWithContentsOfFile:selectedLocationFile];
	
	NSArray *titleKeys = [LocationBooksData allKeys];
	
	for (id titleKey in titleKeys) {
		
		NSString *tmpTitle = titleKey;
		
		NSArray *tmpBookData = [LocationBooksData valueForKey:tmpTitle];

		NSString* author    = [tmpBookData objectAtIndex:0];
		NSString* location  = [tmpBookData objectAtIndex:1];
		NSNumber* latitude  = [tmpBookData objectAtIndex:2];
		NSNumber* longitude = [tmpBookData objectAtIndex:3];
		
		float fTmpLatitude  = [latitude floatValue];
		float fTmpLongitude = [longitude floatValue];
		
		CLLocationDegrees ldLatitude  = (CLLocationDegrees) fTmpLatitude;
		CLLocationDegrees ldLongitude = (CLLocationDegrees) fTmpLongitude;

		CLLocationDegrees ldCurrLatitude = 
		    (CLLocationDegrees) [self.currLatitude doubleValue];
		
		CLLocationDegrees ldCurrLongitude =
		    (CLLocationDegrees) [self.currLongitude doubleValue];
		
		CLLocation *tmpBookLocation = 
		    [[CLLocation alloc] initWithLatitude:ldLatitude longitude:ldLongitude];
		
		CLLocation *tmpCurrLocation =
		    [[CLLocation alloc] initWithLatitude:ldCurrLatitude longitude:ldCurrLongitude];
		
		float fDistance = 
		    (float) [tmpBookLocation getDistanceFrom:tmpCurrLocation];
		
		//		if ((fTmpLatitude >= (delegate.currLatitude - 0.5f)) && (fTmpLatitude <=
		
		if (fDistance <= fSearchRadius) {
			
			NSString* ByLocationEntry = 
		        [NSString stringWithFormat:@"%@ by %@|%@", tmpTitle, author, location];
			
			[self.list addObject:ByLocationEntry];
		}
		
		rowCount = rowCount + 1;
		
		/*
		 // To trim enumeration for performance purposes
		 if (rowCount > 1000) {
		 break;
		 }
		 */
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
	[currSearchType release];
	[currLatitude release];
	[currLongitude release];
	[currRadius release];
	
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
	
	static NSString* ETWBooksCellIdentifier = @"ETWBooksCellIdentifier";
	
	UITableViewCell *cell = 
	    [tableView dequeueReusableCellWithIdentifier:ETWBooksCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:ETWBooksCellIdentifier] autorelease];
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
