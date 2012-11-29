//
//  ETWSearchResultsController.h
//  BiblioPhile
//
//  Created by mac on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface ETWSearchResultsController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray      *list;
	NSString            *currSearchType;
	NSNumber			*currLatitude;
	NSNumber            *currLongitude;
	NSNumber            *currRadius;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSString       *currSearchType;
@property (nonatomic, retain) NSNumber       *currLatitude;
@property (nonatomic, retain) NSNumber       *currLongitude;
@property (nonatomic, retain) NSNumber		 *currRadius;

@end
