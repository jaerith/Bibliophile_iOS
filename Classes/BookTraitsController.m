//
//  BookTraitsController.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookSelectionController.h"
#import "BiblioPhileAppDelegate.h"

#import "BookTraitsController.h"
#import "BookQuotesController.h"
#import "BookCharsController.h"

@implementation BookTraitsController

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

- (void) reload {
}

- (void) retrieveData {
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	// NOTE : Load relevant data
	// NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:delegate.currBookTitle];
	
	NSArray *AllBooks = [delegate.fileParser.bookData allKeys];
	
	NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:[AllBooks objectAtIndex:0]];
	
	NSArray *bookTraitsSelection = [CurrBookData allKeys];
	
	self.list = bookTraitsSelection;
	
	// [bookTraitsSelection release];	
}

// Implement viewWillLoad
- (void)viewWillLoad {
    /*
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	// NOTE : Load relevant data
	NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:delegate.currBookTitle];
	
	NSArray *bookTraitsSelection = [CurrBookData allKeys];
	
	self.list = bookTraitsSelection;
	
	// [bookTraitsSelection release];
	*/
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	charsControllers = [[NSMutableDictionary alloc] init];
	quotesControllers = [[NSMutableDictionary alloc] init];
	
	[self retrieveData];

	/*
	// NOTE : Prepare child controllers
	 
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

	NSArray *bookSelection = [delegate.fileParser.bookData allKeys];
	
	for (NSString *currBook in bookSelection) {
					
        BookCharsController *bookCharsController = 
	        [[BookCharsController alloc] initWithStyle:UITableViewStylePlain];

	    BookQuotesController *bookQuotesController = 
	        [[BookQuotesController alloc] initWithStyle:UITableViewStylePlain];
	
	    bookCharsController.title = @"Characters";
	    bookCharsController.rowImage = nil;
	
	    bookQuotesController.title = @"Quotes";
	    bookQuotesController.rowImage = nil;
	
	    [charsControllers setValue:bookCharsController forKey:currBook];
	    [quotesControllers setValue:bookQuotesController forKey:currBook];
	}
	*/
	
    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[list release];
	[charsControllers release];
	[quotesControllers release];
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
	
	static NSString* BookTraitsCellIdentifier = @"BookTraitsCellIdentifier";
	
	UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:BookTraitsCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									     reuseIdentifier:BookTraitsCellIdentifier] autorelease];
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

	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	NSUInteger row = [indexPath row];
	NSString* selected = [list objectAtIndex:row];

	if ([selected isEqualToString:@"Characters"]) {
		
		/*
		[charsController reload];
		
		BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		*/
		
		if ([charsControllers objectForKey:delegate.currBookTitle] == nil) {
			
			BookCharsController *bookCharsController = 
	            [[BookCharsController alloc] initWithStyle:UITableViewStylePlain];
						
			bookCharsController.title = @"Characters";
			bookCharsController.rowImage = nil;			
			
			[charsControllers setValue:bookCharsController forKey:(delegate.currBookTitle)];
		}
		
		[delegate.navController pushViewController:[charsControllers objectForKey:delegate.currBookTitle] animated:YES];		
	}
	else {
		/*
		[quotesController reload];
		BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		*/
		
		if ([quotesControllers objectForKey:delegate.currBookTitle] == nil) {
			
			BookQuotesController *bookQuotesController = 
	            [[BookQuotesController alloc] initWithStyle:UITableViewStylePlain];
			
			bookQuotesController.title = @"Quotes";
			bookQuotesController.rowImage = nil;			
			
			[quotesControllers setValue:bookQuotesController forKey:(delegate.currBookTitle)];
		}
		
		[delegate.navController pushViewController:[quotesControllers objectForKey:delegate.currBookTitle] animated:YES];		
	}	
}

@end
