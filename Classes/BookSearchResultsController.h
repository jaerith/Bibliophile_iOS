//
//  BookSearchResultsController.h
//  BiblioPhile
//
//  Created by mac on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface BookSearchResultsController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableDictionary *searchResults;
	NSMutableArray      *list;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableDictionary *searchResults;
@property (nonatomic, retain) NSMutableArray      *list;

@end
