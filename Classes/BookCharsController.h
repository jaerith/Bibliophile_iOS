//
//  BookCharsController.h
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@class BookCharDetailsController;

@interface BookCharsController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *list;
	NSDictionary *charDetails;
	
	BookCharDetailsController *charDetailsController;
}

- (void) refreshDisplay;
- (void) reload;
- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSDictionary *charDetails;

-(IBAction) toggleMove;

@end
