//
//  SIBLByBookController.h
//  BiblioPhile
//
//  Created by mac on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface SIBLByBookController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray      *list;
	NSMutableArray      *keys;
	NSMutableDictionary *bookIndex;
	NSMutableArray      *sectionCounts;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray      *list;
@property (nonatomic, retain) NSMutableArray      *keys;
@property (nonatomic, retain) NSMutableDictionary *bookIndex;
@property (nonatomic, retain) NSMutableArray      *sectionCounts;

@end
