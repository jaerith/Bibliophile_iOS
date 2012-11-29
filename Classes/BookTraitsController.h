//
//  BookTraitsController.h
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface BookTraitsController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	NSArray *list;

	NSMutableDictionary *charsControllers;
	NSMutableDictionary *quotesControllers;
}

- (void) reload;
- (void) retrieveData;

@property (nonatomic, retain) NSArray *list;

@end
