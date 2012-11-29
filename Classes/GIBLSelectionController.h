//
//  GIBLSelectionController.h
//  BiblioPhile
//
//  Created by mac on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface GIBLSelectionController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray      *list;
	NSMutableArray      *keys;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray      *list;
@property (nonatomic, retain) NSMutableArray      *keys;

@end
