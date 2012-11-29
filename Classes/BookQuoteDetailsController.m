//
//  BookQuoteDetailsController.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "BookQuoteDetailsController.h"

@implementation BookQuoteDetailsController

@synthesize label;
@synthesize message;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	/*
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	*/
	
	if (self = [super initWithNibName:@"QuoteDetail" bundle:[NSBundle mainBundle]]) {
		// Custom initialization
	}
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewWillAppear:(BOOL)animated {
	label.text = message;
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	// "Movable" button
	UIBarButtonItem *emailButton = 
		[[UIBarButtonItem alloc] initWithTitle:@"Email" 
								 style:UIBarButtonItemStyleBordered 
								 target:self 
								 action:@selector(forwardQuote)];
	
	// Just in case
	if ([MFMailComposeViewController canSendMail])
	    emailButton.enabled = YES;
	
	self.navigationItem.rightBarButtonItem = emailButton;
	
	[emailButton release];
		
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
	[label release];
	[message release];
    [super dealloc];
}

- (IBAction) forwardQuote {
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
		
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	
	NSString *emailBody =
	[NSString stringWithFormat:@"\"%@\"\n\n                          %@\n\n\n\nPresented by bibliofile.net", 
	 message, delegate.currBookTitle];
	
	controller.mailComposeDelegate = self;
	[controller setSubject:@"Check Out This Quote"];
	[controller setMessageBody:emailBody isHTML:NO];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

#pragma mark -
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

@end
