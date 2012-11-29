//
//  BookSearchGenericController.m
//  BiblioPhile
//
//  Created by mac on 7/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "BookSearchResultsController.h"
#import "BookSearchGenericController.h"

@implementation BookSearchGenericController

@synthesize column1Image;
@synthesize column2Image;
@synthesize column3Image;
@synthesize column4Image;

@synthesize categoryPicker;

@synthesize categoryPickerReport;

@synthesize spinButton;
@synthesize resetButton;
@synthesize searchButton;

@synthesize allCategoryData;

@synthesize column1List;
@synthesize column2List;
@synthesize column3List;
@synthesize column4List;

@synthesize currSelectedPath;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    if (self = [super initWithNibName:@"BookSearchPicker" bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.categoryPicker.delegate = self;
	
	searchButton.hidden = YES;
	
	categoryPickerReport.font = [UIFont boldSystemFontOfSize:11];
	
	[currSelectedPath addObject:@"DummyData"];

	[categoryPicker selectRow:0 inComponent:kCol1Component animated:YES];
	
	if ([self.title isEqualToString:@"Neo"]) {
		
		UIImage* imageHero     = [UIImage imageNamed:@"protagonist.jpg"];
		UIImage* imageVillain  = [UIImage imageNamed:@"antagonist.jpg"];
		UIImage* imageStory    = [UIImage imageNamed:@"book.png"];
		UIImage* imageConflict = [UIImage imageNamed:@"battle.jpg"];
		
		self.column1Image.image = imageStory;
		self.column2Image.image = imageConflict;
		self.column3Image.image = imageHero;
		self.column4Image.image = imageVillain;
	}

	// Warning
	NSString *warningMsg = 
	    [NSString stringWithFormat:@"This applet presents the potential of giving the users a new way to look through the categories of books.  In addition, the 2 tab buttons on the bottom suggest an old way and a possible new way.  However, be gentle; this applet is a bit unstable."];
	
	UIAlertView *alert = 
	    [[UIAlertView alloc] initWithTitle:@"Caveat Emptor" 
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
	
	[column1Image release];
	[column2Image release];
	[column3Image release];
	[column4Image release];
	
	[categoryPicker release];
	
	[categoryPickerReport release];
	
	[spinButton release];
	[resetButton release];
	[searchButton release];	
	
	[column1List release];
	[column2List release];
	[column3List release];
	[column4List release];

    [super dealloc];
}

-(id)initWithTabBar:(NSString*)viewType {
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	if ( currSelectedPath == nil ) {
		currSelectedPath = [[NSMutableArray alloc] init];
	}
	
	if ([self init]) {
		
		if ([viewType isEqualToString:@"Classic"]) {
			
			//this is the label on the tab button itself
			self.title = @"Classic";
			
			UIImage* imageClassic = [UIImage imageNamed:@"parthenon_icon.png"];
			self.tabBarItem.image = imageClassic;
		
			//use whatever image you want and add it to your project
			// self.tabBarItem.image = [UIImage imageNamed:@"name_gray.png"];
		
			// set the long name shown in the navigation bar at the top
			self.navigationItem.title=@"Classic";
						
			self.allCategoryData = delegate.oldCategoryData;
			self.column1List     = [self.allCategoryData allKeys];
		}
		else {
		
			//this is the label on the tab button itself
			self.title = @"Neo";
			
			UIImage* imageNeo = [UIImage imageNamed:@"hearst_building.png"];
			self.tabBarItem.image = imageNeo;
			
			//use whatever image you want and add it to your project
			// self.tabBarItem.image = [UIImage imageNamed:@"name_gray.png"];
			
			// set the long name shown in the navigation bar at the top
			self.navigationItem.title=@"Neo";
			
			self.allCategoryData = delegate.newCategoryData;
			self.column1List     = [self.allCategoryData allKeys];			
		}
	}
	
	return self;	
}

- (void) updateCategoryReport:(NSString*) subCategory {
	
	NSMutableString *newReport = [[NSMutableString alloc] init];
	
	[currSelectedPath addObject:subCategory];
		
	int nIndex = 0;
	
	// NOTE : Assemble list from book collection
	for (id key in currSelectedPath) {
		
		NSString* tmpCategory = key;
		
		if (nIndex > 0) {
			[newReport appendString:@"->"];
		}
		
		[newReport appendString:tmpCategory];
		
		nIndex = nIndex + 1;
	}
	
	self.categoryPickerReport.text = newReport;
	
	[newReport release];
}

#pragma mark -
#pragma mark Button Handlers
- (IBAction) spin {
	
	[self reset];
	
	[currSelectedPath removeAllObjects];

	NSArray      *FirstChoices    = self.column1List;
	int          nFirstLevelCount = [FirstChoices count];
	int          nFirstChoice     = random() % nFirstLevelCount;
	NSString     *FirstChoice     = [FirstChoices objectAtIndex:nFirstChoice];
	NSDictionary *SecondLevel     = [allCategoryData valueForKey:FirstChoice];
	// [categoryPicker selectRow:nFirstChoice inComponent:kCol1Component animated:YES];
	// [categoryPicker reloadComponent:kCol1Component];
	
	if ( [currSelectedPath count] == 0 ) {
		[self updateCategoryReport:FirstChoice];
	}
	
	NSArray      *SecondChoices    = [SecondLevel allKeys];
	int          nSecondLevelCount = [SecondChoices count];
	int          nSecondChoice     = random() % nSecondLevelCount;
	NSString     *SecondChoice     = [SecondChoices objectAtIndex:nSecondChoice];
	NSDictionary *ThirdLevel       = [SecondLevel valueForKey:SecondChoice];
	// [categoryPicker selectRow:nSecondChoice inComponent:kCol2Component animated:YES];
	// [categoryPicker reloadComponent:kCol2Component];
	
	if ( [currSelectedPath count] == 1 ) {
		[self updateCategoryReport:SecondChoice];
	}
	
	NSArray      *ThirdChoices    = [ThirdLevel allKeys];
	int          nThirdLevelCount = [ThirdChoices count];
	int          nThirdChoice     = random() % nThirdLevelCount;
	NSString     *ThirdChoice     = [ThirdChoices objectAtIndex:nThirdChoice];
	NSDictionary *FourthLevel     = [ThirdLevel valueForKey:ThirdChoice];
	// [categoryPicker selectRow:nThirdChoice inComponent:kCol3Component animated:YES];
	// [categoryPicker reloadComponent:kCol3Component];
	
	if ( [currSelectedPath count] == 2 ) {
		[self updateCategoryReport:ThirdChoice];
	}

	NSArray      *FourthChoices    = [FourthLevel allKeys];
	int          nFourthLevelCount = [FourthChoices count];
	int          nFourthChoice     = random() % nFourthLevelCount;
	NSString     *FourthChoice     = [FourthChoices objectAtIndex:nFourthChoice];	
	// [categoryPicker selectRow:nFourthChoice inComponent:kCol4Component animated:YES];
	// [categoryPicker reloadComponent:kCol4Component];
	
	if ( [currSelectedPath count] == 3 ) {
		[self updateCategoryReport:FourthChoice];
	}
	
	self.searchButton.hidden = NO;
	currSearchData = [FourthLevel valueForKey:FourthChoice];
}

- (IBAction) reset {
	
	self.column2List = nil;
	self.column3List = nil;
	self.column4List = nil;
	
	self.searchButton.hidden = YES;
	
	[currSelectedPath removeAllObjects];
	
	[categoryPicker selectRow:0 inComponent:kCol1Component animated:YES];
	
	NSString *selectedCol1Value = [self.column1List objectAtIndex:0];
	[self updateCategoryReport:selectedCol1Value];
	
	[categoryPicker reloadComponent:kCol2Component];
	[categoryPicker reloadComponent:kCol3Component];
	[categoryPicker reloadComponent:kCol4Component];
}

- (IBAction) search {
	
	// self.searchButton.hidden = YES;
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	BookSearchResultsController *booksearchResultsController =
	    [[[BookSearchResultsController alloc] init] autorelease];
	
	booksearchResultsController.title         = @"Search Results";
	booksearchResultsController.searchResults = [currSearchData mutableCopy];
	
	[delegate.navController pushViewController:booksearchResultsController animated:YES];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*) pickerView {
	
	return 4;
}

- (NSInteger) pickerView:(UIPickerView*) pickerView
 numberOfRowsInComponent:(NSInteger) component {
	
	if (component == kCol1Component) {
		return [self.column1List count];
	}
	else if (component == kCol2Component) {
		return [self.column2List count];
	}
	else if (component == kCol3Component) {
		return [self.column3List count];
	}
	else if (component == kCol4Component) {
		return [self.column4List count];
	}
	
	return 0;
}

#pragma mark Picker Delegate Methods
- (NSString*) pickerView:(UIPickerView*) pickerView
titleForRow:(NSInteger) row
forComponent:(NSInteger) component {
	
	if (component == kCol1Component) {
		if (self.column1List != nil) {
		    return [self.column1List objectAtIndex:row];
		}
		else {
			return 0;
		}
	}
	else if (component == kCol2Component) {
		if (self.column2List != nil) {
			return [self.column2List objectAtIndex:row];
		}
		else {
			return 0;
		}		
	}
	else if (component == kCol3Component) {
		if (self.column3List != nil) {
			return [self.column3List objectAtIndex:row];
		}
		else {
			return 0;
		}		
	}
	else if (component == kCol4Component) {
		if (self.column4List != nil) {
			return [self.column4List objectAtIndex:row];
		}
		else {
			return 0;
		}		
	}
	
	return @"";
}

- (void) pickerView:(UIPickerView*) pickerView
didSelectRow:(NSInteger) row
inComponent:(NSInteger) component {
	
	if (component == kCol1Component) {
		
		self.searchButton.hidden = YES;
		
		NSString     *selectedCol1Value = [self.column1List objectAtIndex:row];
        NSDictionary *nextSelectedLevel = [allCategoryData valueForKey:selectedCol1Value];
		NSArray      *nextKeyArray      = [nextSelectedLevel allKeys];
		
		self.column2List = nextKeyArray;
		
		[categoryPicker selectRow:0 inComponent:kCol2Component animated:YES];
		
		if ([currSelectedPath count] >= 0) {
			
			if ([currSelectedPath count] == 4) {
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
			}
			else if ([currSelectedPath count] == 3) {
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
			}
			else if ([currSelectedPath count] == 2) {
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
			}
			else if ([currSelectedPath count] == 1) {
				[currSelectedPath removeLastObject];
			}
			
			[self updateCategoryReport:selectedCol1Value];
		}
		
		[categoryPicker reloadComponent:kCol2Component];
	}
	else if (component == kCol2Component) {
		
		self.searchButton.hidden = YES;

		NSString	 *selectedCol1Value = [currSelectedPath objectAtIndex:0];
		NSString     *selectedCol2Value = [self.column2List objectAtIndex:row];
		NSDictionary *firstLevel        = [allCategoryData valueForKey:selectedCol1Value];
        NSDictionary *nextSelectedLevel = [firstLevel valueForKey:selectedCol2Value];
		NSArray      *nextKeyArray      = [nextSelectedLevel allKeys];
		
		self.column3List = nextKeyArray;
		
		[categoryPicker selectRow:0 inComponent:kCol3Component animated:YES];
		
		if ([currSelectedPath count] >= 1) {
			
			if ([currSelectedPath count] == 4) {
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
			}
			else if ([currSelectedPath count] == 3) {
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
			}
			else if ([currSelectedPath count] == 2) {
				[currSelectedPath removeLastObject];
			}
			
			[self updateCategoryReport:selectedCol2Value];
		}
		
		[categoryPicker reloadComponent:kCol3Component];
	}
	else if (component == kCol3Component) {
		
		self.searchButton.hidden = YES;
		
		NSString     *selectedCol1Value = [currSelectedPath objectAtIndex:0];
		NSString	 *selectedCol2Value = [currSelectedPath objectAtIndex:1];
		NSString     *selectedCol3Value = [self.column3List objectAtIndex:row];
		NSDictionary *firstLevel        = [allCategoryData valueForKey:selectedCol1Value];
		NSDictionary *secondLevel       = [firstLevel valueForKey:selectedCol2Value];
        NSDictionary *nextSelectedLevel = [secondLevel valueForKey:selectedCol3Value];
		NSArray      *nextKeyArray      = [nextSelectedLevel allKeys];
		
		self.column4List = nextKeyArray;
		
		[categoryPicker selectRow:0 inComponent:kCol4Component animated:YES];
		
		if ([currSelectedPath count] >= 2) {
			
			if ([currSelectedPath count] == 4) {
				[currSelectedPath removeLastObject];
				[currSelectedPath removeLastObject];
			}
			else if ([currSelectedPath count] == 3) {
				[currSelectedPath removeLastObject];
			}
			
			[self updateCategoryReport:selectedCol3Value];
		}
		
		[categoryPicker reloadComponent:kCol4Component];
	}
	else if (component == kCol4Component) {
		
		NSString *selectedCol1Value = [currSelectedPath objectAtIndex:0];
		NSString *selectedCol2Value = [currSelectedPath objectAtIndex:1];
		NSString *selectedCol3Value = [currSelectedPath objectAtIndex:2];
		NSString *selectedCol4Value = [self.column4List objectAtIndex:row];
		
		NSDictionary *firstLevel  = [allCategoryData valueForKey:selectedCol1Value];
		NSDictionary *secondLevel = [firstLevel valueForKey:selectedCol2Value];
        NSDictionary *thirdLevel  = [secondLevel valueForKey:selectedCol3Value];
		
		currSearchData = [thirdLevel valueForKey:selectedCol4Value];

		if ([currSelectedPath count] >= 3) {
			
			if ([currSelectedPath count] == 4) {
				[currSelectedPath removeLastObject];
			}
			
			[self updateCategoryReport:selectedCol4Value];
		}
		
		searchButton.hidden = NO;
	}
}
		
@end
