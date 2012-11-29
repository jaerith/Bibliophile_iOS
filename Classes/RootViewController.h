//
//  RootViewController.h
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define kAllBookData    0
#define kMagicQuoteBall 1
#define SIBLData        2
#define Locations       3
#define ExploreTheWorld 4

/*
#define kMyLibrary      2
#define GIBLData        4
#define YCQM            6
#define CatSearch       7
*/

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController
    <UITableViewDelegate, UITableViewDataSource> {
        NSArray *controllers;
}

@property (nonatomic, retain) NSArray* controllers;

@end
