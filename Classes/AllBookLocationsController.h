//
//  AllBookLocationsController.h
//  BiblioPhile
//
//  Created by mac on 6/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface AllBookLocationsController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *list;
	
	NSMutableString *targetFile;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray  *list;
@property (nonatomic, retain) NSMutableString *targetFile;

@end
