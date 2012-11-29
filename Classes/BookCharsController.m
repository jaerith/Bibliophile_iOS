//
//  BookCharsController.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BookCharsController.h"
#import "BookCharDetailsController.h"
#import "BiblioPhileAppDelegate.h"

@implementation BookCharsController

@synthesize charDetails;
@synthesize list;

-(IBAction)toggleMove{
	[self.tableView setEditing:!self.tableView.editing animated:YES];
}

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

- (void) refreshDisplay {
	[self.tableView reloadData];
}

- (void) reload {
	[self retrieveData];
	[self.tableView reloadData];
	
	// [self performSelector:(@selector(refreshDisplay:)) withObject:nil afterDelay:0.5];
	// [self.tableView setNeedsDisplay];
	// [self.tableView reloadData];
}

- (void) retrieveData {
	
	 BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	 
	 // NOTE : Load relevant data
	 NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:delegate.currBookTitle];
	 
	 charDetails = [CurrBookData valueForKey:@"Characters"];
	 // NSDictionary* QuoteData = [CurrBookData valueForKey:@"Quotes"];
	 
	 NSArray *charSelection = [charDetails allKeys];
	 
	 self.list = [charSelection mutableCopy];
	 
	 // [charSelection release];
}

// Implement viewWillLoad
- (void)viewWillLoad {

	/*
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	// NOTE : Load relevant data
	NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:delegate.currBookTitle];
	
	NSDictionary* CharData = [CurrBookData valueForKey:@"Characters"];
	// NSDictionary* QuoteData = [CurrBookData valueForKey:@"Quotes"];
	
	NSArray *charSelection = [CharData allKeys];
	
	self.list = charSelection;
	
	// [charSelection release];
	*/
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self retrieveData];
	
	// NOTE : Prepare child controller
	if (charDetailsController == nil) {
	    BookCharDetailsController *bookCharDetailsController = 
	        [[BookCharDetailsController alloc] init];
	
	    /*
	    bookCharDetailsController.title = @"Character Details";
	    bookCharDetailsController.rowImage = nil;
   	    */
	
	    charDetailsController = bookCharDetailsController;
		
		// "Movable" button
		UIBarButtonItem *moveButton = 
		[[UIBarButtonItem alloc] initWithTitle:@"Move" 
										 style:UIBarButtonItemStyleBordered 
										target:self 
										action:@selector(toggleMove)];
		
		self.navigationItem.rightBarButtonItem = moveButton;
		
		[moveButton release];		
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
	[charDetailsController release];
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
	
	static NSString* BookCharsCellIdentifier = @"BookCharsCellIdentifier";
	
	UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:BookCharsCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									     reuseIdentifier:BookCharsCellIdentifier] autorelease];
		
		cell.showsReorderControl = YES;
	}
	
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];
	cell.text = rowString;
	
	// [rowString release];
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView*)tableView 
    canMoveRowAtIndexPath:(NSIndexPath*)indexPath {
	return YES;
}

- (void)tableView:(UITableView*)tableView
	moveRowAtIndexPath:(NSIndexPath*)fromIndexPath 
    toIndexPath:(NSIndexPath*)toIndexPath {
	
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	
	id object = [[list objectAtIndex:fromRow] retain];
	
	[list removeObjectAtIndex:fromRow];
	[list insertObject:object atIndex:toRow];
	[object release];
	
	/*
	NSString *tempValue = [[list objectAtIndex:fromRow] copy];
	
	[list removeObjectAtIndex:fromRow];
	
	[list insertObject:tempValue atIndex:toRow];
	
	[tempValue release];
	*/
}


#pragma mark -
#pragma mark Table Delegate Methods
- (UITableViewCellAccessoryType) tableView:(UITableView*)tableView
		  accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath{
	return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void) tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	 NSUInteger row = [indexPath row];
	 NSString* selected = [list objectAtIndex:row];
	 
	 charDetailsController.title = @"DETAILS";
	 charDetailsController.message = [charDetails valueForKey:selected];
	 // quoteDetailsController.message = @"I must not fear. Fear is the mind-killer. Fear is the little-death that brings total obliteration. I will face my fear. I will permit it to pass over me and through me. And when it has gone past I will turn the inner eye to see its path. Where the fear has gone there will be nothing. Only I will remain.";
	 
	 BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	 
	 [delegate.navController pushViewController:charDetailsController animated:YES];
}

@end
