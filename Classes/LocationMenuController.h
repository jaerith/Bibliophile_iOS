//
//  LocationMenuController.h
//  BiblioPhile
//
//  Created by mac on 6/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@class AllBookLocationsController;
@class BooksByCurrentLocationController;

@interface LocationMenuController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *list;
	NSMutableDictionary *mapRegionToFile;
		
	BooksByCurrentLocationController *booksbyCurrLocController;
}

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSMutableDictionary *mapRegionToFile;

@end
