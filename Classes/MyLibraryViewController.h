//
//  MyLibraryViewController.h
//  BiblioPhile
//
//  Created by mac on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@class SampleChapterController;

@interface MyLibraryViewController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *list;
		
	SampleChapterController *sampleChapterController;
}

- (void) refreshDisplay;
- (void) reload;
- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray *list;

@end
