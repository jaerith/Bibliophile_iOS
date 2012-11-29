//
//  YCQMPickQuoteController.h
//  BiblioPhile
//
//  Created by mac on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"

@interface YCQMPickQuoteController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray      *list;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray *list;

@end
