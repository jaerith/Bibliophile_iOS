//
//  MyLibraryViewController.m
//  BiblioPhile
//
//  Created by mac on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyLibraryViewController.h"
#import "SampleChapterController.h"
#import "BiblioPhileAppDelegate.h"

@implementation MyLibraryViewController

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
	
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	// NOTE : Load relevant data	
	NSArray *imageSelection = [delegate.myLibraryImages allKeys];
	
	self.list = [imageSelection mutableCopy];
	
	// [charSelection release];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	[self retrieveData];
	
	// NOTE : Prepare child controller
	if (sampleChapterController == nil) {
		
	    SampleChapterController *tempController = 
		    [[SampleChapterController alloc] init];
		
	    /*
		 tempController.title = @"Character Details";
		 tempController.rowImage = nil;
		 */
		
	    sampleChapterController = tempController;		
	}
	
	// Warning
	NSString *warningMsg = 
	    [NSString stringWithFormat:@"This applet would allow you to carry the first chapters of certain prized books.  Since the first chapters are given away as samples anyway, it would be a novelty."];
	
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
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[list release];
	[sampleChapterController release];
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
	
	static NSString* MyLibraryCellIdentifier = @"MyLibraryCellIdentifier";
	
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	UITableViewCell *cell = 
	    [tableView dequeueReusableCellWithIdentifier:MyLibraryCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
			        reuseIdentifier:MyLibraryCellIdentifier] autorelease];
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
	
	cell.font  = [UIFont systemFontOfSize:10];
	// cell.text  = rowString;
	cell.image = [delegate.myLibraryImages valueForKey:rowString];
	
	// [rowString release];
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
 - (CGFloat) tableView:(UITableView*)tableView
 heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	 
	 BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	 
	 NSUInteger row      = [indexPath row];
	 NSString *rowString = [list objectAtIndex:row];
	 
	 UIImage *tmpImg = [delegate.myLibraryImages valueForKey:rowString];
	 
	 return tmpImg.size.height + 30;	 
 }

- (UITableViewCellAccessoryType) tableView:(UITableView*)tableView
		  accessoryTypeForRowWithIndexPath:(NSIndexPath*)indexPath{
	return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void) tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	BiblioPhileAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	NSUInteger row = [indexPath row];
	NSString* selected = [list objectAtIndex:row];
	
	sampleChapterController.title   = selected;
	sampleChapterController.message = [delegate.myLibrarySamples valueForKey:selected];
	
	[delegate.navController pushViewController:sampleChapterController animated:YES];
}

@end
