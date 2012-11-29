//
//  MagicQuoteBall.m
//  BiblioPhile
//
//  Created by mac on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BiblioPhileAppDelegate.h"
#import "MagicQuoteBall.h"

@implementation MagicQuoteBall

@synthesize Hint;
@synthesize BookTitle;
@synthesize Quote;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	/*
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	*/
	 	
	if (self = [super initWithNibName:@"MagicQuoteBall" bundle:[NSBundle mainBundle]]) {
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
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	
	accel.delegate = self;
	accel.updateInterval = kUpdateInterval;
	
	quoteShowing   = FALSE;
	
	self.Hint.text      = @"Shake to get a quote!";
	self.BookTitle.text = @" ";
	self.Quote.text     = @" ";
	
    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    [Hint release];
	[BookTitle release];
	[Quote release];	
	
    [super dealloc];
}

- (void) generateRandomQuote {
	
	static BOOL seeded = NO;
	
	if (!seeded) {
		seeded = YES;
		srandom(time(NULL));
	}
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	// NOTE : Load relevant data
	NSArray* AllBookTitles = [delegate.fileParser.bookData allKeys];
	
	while (YES) {
		
		int     TotalBookCount  = [AllBookTitles count];
		CGFloat RandomFloat     = (CGFloat) random();
		CGFloat RandomScalar    = RandomFloat / ((CGFloat) RAND_MAX);
		int     RandomBookIndex = RandomScalar * TotalBookCount;
	
		NSString* TmpBookTitle = [AllBookTitles objectAtIndex:RandomBookIndex];
		
		NSDictionary* CurrBookData = [delegate.fileParser.bookData valueForKey:TmpBookTitle];	
		NSDictionary* QuoteData    = [CurrBookData valueForKey:@"Quotes"];

		NSArray *quoteSelection = [QuoteData allKeys];

		if ([quoteSelection count] > 0) {

			int TotalQuoteCount  = [quoteSelection count];
			RandomFloat          = (CGFloat) random();
			RandomScalar         = RandomFloat / ((CGFloat) RAND_MAX);
		
			int RandomQuoteIndex = RandomScalar * TotalQuoteCount;

			NSString *RandomQuote = [quoteSelection objectAtIndex:RandomQuoteIndex];
	
			self.BookTitle.text = TmpBookTitle;
			self.Quote.text     = RandomQuote;
			break;
		}
	}
}

#pragma mark -
- (void) accelerometer:(UIAccelerometer*) accelerometer
		 didAccelerate:(UIAcceleration*) acceleration {
	
	if (!quoteShowing) {
		if (acceleration.x > kAccelerationThreshold
			|| acceleration.y > kAccelerationThreshold
			|| acceleration.z > kAccelerationThreshold) {
			
			[self generateRandomQuote];
			
			self.Hint.text    = @"Touch to reset.";
			quoteShowing = TRUE;
		}
	}
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	
	self.Hint.text      = @"Shake to get a quote!";
	self.BookTitle.text = @" ";
	self.Quote.text     = @" ";
	
	quoteShowing = FALSE;	
}

@end
