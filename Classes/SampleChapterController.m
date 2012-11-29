//
//  SampleChapterController.m
//  BiblioPhile
//
//  Created by mac on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SampleChapterController.h"


@implementation SampleChapterController

@synthesize textView;
@synthesize message;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	
	if (self = [super initWithNibName:@"SampleChapter" bundle:[NSBundle mainBundle]]) {
		//if (self = [super initWithNibName:"CharDetail" bundle:nil])
		//	int x = 1;
	}
	
    return self;	
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewWillAppear:(BOOL)animated {
	textView.text = message;
	[super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
		
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
	[textView release];
	[message release];
    [super dealloc];
}


@end
