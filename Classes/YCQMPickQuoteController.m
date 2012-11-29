//
//  YCQMPickQuoteController.m
//  BiblioPhile
//
//  Created by mac on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "YCQMPickQuoteController.h"
#import "YCQMImageSelection.h"

@implementation YCQMPickQuoteController

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
	
	// NOTE : Load relevant data
	NSArray* UnsortedBookTitles = [delegate.fileParser.bookData allKeys];
	
	NSArray *AlBookTitles = [UnsortedBookTitles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	
	// NOTE : Assemble list from book collection
	for (id key in AlBookTitles) {
		
		NSString *tmpTitle = key;
		
		NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:tmpTitle];
	
		NSDictionary* QuoteData = [CurrBookData valueForKey:@"Quotes"];
	
		NSArray *quoteSelection = [QuoteData allKeys];
		
		for (id key2 in quoteSelection) {
			
			NSString *tmpQuote = key2;
			
			NSString* QuoteEntry = 
				[NSString stringWithFormat:@"%@|%@", tmpQuote, tmpTitle];
			
			[self.list addObject:QuoteEntry];
		}
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self retrieveData];
	
	// Warning
	NSString *warningMsg = 
	    [NSString stringWithFormat:@"This applet will allow you to create postcards from your own images and from book quotes.  Afterwards, you can both save it locally and/or email it to your friends via the final screen's top-right button."];
	
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
	
	static NSString* YMQMPickQuoteCellIdentifier = @"YMQMPickQuoteCellIdentifier";
	
	UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:YMQMPickQuoteCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:YMQMPickQuoteCellIdentifier] autorelease];
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
	
	NSString* quoteField = [rowData objectAtIndex:0];
	NSString* titleField = [rowData objectAtIndex:1];
	
	CGRect quoteRect = CGRectMake(5.0, 0.0, 240, 75);
	UILabel *quoteView = [[UILabel alloc] initWithFrame:quoteRect];
	quoteView.text = quoteField;
	quoteView.numberOfLines = 3;
	quoteView.textColor = [UIColor blackColor];
	quoteView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:quoteView];
	
	CGRect titleRect = CGRectMake(5.0, 76.0, 240, 50);
	UILabel *titleView = [[UILabel alloc] initWithFrame:titleRect];
	titleView.text = titleField;
	titleView.numberOfLines = 2;
	titleView.textColor = [UIColor grayColor];
	titleView.font = [UIFont boldSystemFontOfSize:12];
	[cell.contentView addSubview:titleView];	
	
	// [quoteView release];
	// [titleView release];
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (CGFloat) tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	return 125;	 
}

- (UITableViewCellAccessoryType) tableView:(UITableView*)tableView
		  accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath{
	
	// return UITableViewCellAccessoryNone;
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void) tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	NSUInteger row = [indexPath row];
	NSString* selected = [list objectAtIndex:row];
	
	NSArray *rowData = [selected componentsSeparatedByString:@"|"];
	
	NSString* quoteField = [rowData objectAtIndex:0];
	NSString* titleField = [rowData objectAtIndex:1];

	BiblioPhileAppDelegate *delegate = 
		(BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	 
	YCQMImageSelection *ycqmImageSelection =
		[[[YCQMImageSelection alloc] init] autorelease];
	
	NSString *tmpText =
		[NSString stringWithFormat:@"\"%@\"\n\n                          %@", quoteField, titleField];

	ycqmImageSelection.title = @"Press to Save";
	ycqmImageSelection.quoteText = [tmpText mutableCopy];
	[delegate.navController pushViewController:ycqmImageSelection animated:YES];
}

@end
