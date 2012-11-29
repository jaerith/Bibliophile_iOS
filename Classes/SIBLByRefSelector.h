//
//  SIBLByRefSelector.h
//  BiblioPhile
//
//  Created by mac on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define kByBook       0
#define kByPerformer  1
#define kByFoundSongs 2

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@class SIBLByBookController;
@class SIBLByPerformerController;
@class SIBLByFoundSongController;

@interface SIBLByRefSelector : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *list;
	
	SIBLByBookController      *siblByBookController;
	SIBLByPerformerController *siblByPerformerController;
	SIBLByFoundSongController *siblByFoundSongController;
}	

@property (nonatomic, retain) NSMutableArray *list;

@end
