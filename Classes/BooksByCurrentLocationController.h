//
//  BooksByCurrentLocationController.h
//  BiblioPhile
//
//  Created by mac on 6/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface BooksByCurrentLocationController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray      *list;
	NSNumber			*currLatitude;
	NSNumber            *currLongitude;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSNumber       *currLatitude;
@property (nonatomic, retain) NSNumber       *currLongitude;

@end
