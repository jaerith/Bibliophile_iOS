//
//  SIBLByPerformerController.h
//  BiblioPhile
//
//  Created by mac on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface SIBLByPerformerController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray      *list;
	NSMutableArray      *keys;
	NSMutableDictionary *performerIndex;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray      *list;
@property (nonatomic, retain) NSMutableArray      *keys;
@property (nonatomic, retain) NSMutableDictionary *performerIndex;

@end
