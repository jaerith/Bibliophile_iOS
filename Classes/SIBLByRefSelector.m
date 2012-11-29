//
//  SIBLByRefSelector.m
//  BiblioPhile
//
//  Created by mac on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "SIBLByRefSelector.h"
#import "SIBLByBookController.h"
#import "SIBLByPerformerController.h"
#import "SIBLByFoundSongController.h"

@implementation SIBLByRefSelector

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];	
	
	list = [[NSMutableArray alloc] init];
	
	[list addObject:@"By Book"];
	[list addObject:@"By Performer"];
	[list addObject:@"Found on Your iPod"];

	siblByBookController      = [[SIBLByBookController alloc] initWithStyle:UITableViewStylePlain];
	siblByPerformerController = [[SIBLByPerformerController alloc] initWithStyle:UITableViewStylePlain];
	siblByFoundSongController = [[SIBLByFoundSongController alloc] initWithStyle:UITableViewStylePlain];

	NSString *warningMsg;
	int nCurrSongCount = [delegate.allSongsOnIpod count];
	
	/*
	warningMsg = 
	    [NSString stringWithFormat:@"The 'Found on Your iPod' choice will take a minute to search your music library.  Please be patient.  %d songs matched.",
	              [delegate.allSongsOnIpod count]];
	*/
	
	/*
	if (nCurrSongCount < 500) {
		
	    warningMsg = 
		    [NSString stringWithFormat:@"The 'Found on Your iPod' choice might take a minute to search your music library.  Please be patient."];
	}
	else {
		
		warningMsg =
			[NSString stringWithFormat:@"The 'Found on Your iPod' choice might take a few more seconds to search your music library.  Please be patient."];
	}
	*/
	
	warningMsg =
	    [NSString stringWithFormat:@"The 'Found on Your iPod' choice might take a few more seconds to search your music library.  Please be patient."];
	
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
	[siblByBookController release];
	[siblByPerformerController release];
	[SIBLByFoundSongController release];
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
	
	static NSString* SIBLCellIdentifier = @"SIBLCellIdentifier";
	
	UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:SIBLCellIdentifier];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
									   reuseIdentifier:SIBLCellIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];
	
	cell.text = rowString;
	
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
	
	NSUInteger row = [indexPath row];
	NSString* selected = [list objectAtIndex:row];
			
	BiblioPhileAppDelegate *delegate = 
		(BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	if (row == kByBook) {
		siblByBookController.title = selected;
		[delegate.navController pushViewController:siblByBookController animated:YES];
	}
	else if (row == kByPerformer) {
		siblByPerformerController.title = selected;
		[delegate.navController pushViewController:siblByPerformerController animated:YES];
	}
	else {
		BOOL ready = [delegate isSongDataPullDone];
		
		if (ready) {
			siblByFoundSongController.title = selected;
			
			[delegate.navController pushViewController:siblByFoundSongController 
								    animated:YES];
		}
		else {
			
			NSString* warningMsg = 
			    [NSString stringWithFormat:@"The app is still searching your iPod.  It should be done in a few seconds."];
			
			UIAlertView *alert = 
			    [[UIAlertView alloc] initWithTitle:@"Info" 
								     message:warningMsg delegate:nil 
									 cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			
			[alert show];
			[alert release];
		}
	}
}

@end
