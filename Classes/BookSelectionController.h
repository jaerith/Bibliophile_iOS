//
//  BookSelectionController.h
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@class BookTraitsController;

@interface BookSelectionController : SecondLevelViewController
<UITableViewDelegate, UITableViewDataSource> {
	
	NSArray *list;
	BookTraitsController *childController;
}

@property (nonatomic, retain) NSArray *list;

@end
