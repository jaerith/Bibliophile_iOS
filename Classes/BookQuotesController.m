//
//  BookQuotesController.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookQuotesController.h"
#import "BookQuoteDetailsController.h"
#import "BiblioPhileAppDelegate.h"

@implementation BookQuotesController

@synthesize list;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
		
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) refreshDisplay {
	[self.tableView reloadData];
}

- (void) reload {
	[self retrieveData];
	[self.tableView reloadData];
}	

- (void) retrieveData {
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	// NOTE : Load relevant data
	NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:delegate.currBookTitle];
	
	NSDictionary* QuoteData = [CurrBookData valueForKey:@"Quotes"];
	
	NSArray *quoteSelection = [QuoteData allKeys];
	
	self.list = quoteSelection;
	
	// [quoteSelection release];
}

// Implement viewWillLoad
- (void)viewWillLoad {	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self retrieveData];
	
	// NOTE : Prepare child controller
	if (quoteDetailsController == nil) {
	    BookQuoteDetailsController *bookQuoteDetailsController = 
		    [[BookQuoteDetailsController alloc] init];
		
	    /*
		 bookCharDetailsController.title = @"Character Details";
		 bookCharDetailsController.rowImage = nil;
		 */
		
	    quoteDetailsController = bookQuoteDetailsController;
	}	
	
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
	[quoteDetailsController release];
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
	
	static NSString* BookQuotesCellIdentifier = @"BookQuotesCellIdentifier";
	
	UITableViewCell *cell = 
	    [tableView dequeueReusableCellWithIdentifier:BookQuotesCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:BookQuotesCellIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];

	/*
	CGRect contentRect = CGRectMake(5.0, 0.0, 240, 120);
    UILabel *textView = [[UILabel alloc] initWithFrame:contentRect];
	
	textView.text = rowString;
	textView.numberOfLines = 5;
	textView.textColor = [UIColor grayColor];
	textView.font = [UIFont systemFontOfSize:12];
	[cell.contentView addSubview:textView];
	[textView release];
	*/

	cell.font = [UIFont systemFontOfSize:10];
	cell.text = rowString;
	
	// [rowString release];
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
/*
- (CGFloat) tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	return 120;
}
*/

- (UITableViewCellAccessoryType) tableView:(UITableView*)tableView
		  accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath{
	return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void) tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	 NSUInteger row = [indexPath row];
	 NSString* selected = [list objectAtIndex:row];
	
	 quoteDetailsController.title = @"QUOTE";
	 quoteDetailsController.message = selected;
	 // quoteDetailsController.message = @"I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit it to pass over me and through me. And when it has gone past I will turn the inner eye to see its path. Where the fear has gone there will be nothing. Only I will remain.";

	 BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	 
	 [delegate.navController pushViewController:quoteDetailsController animated:YES];
}

@end
