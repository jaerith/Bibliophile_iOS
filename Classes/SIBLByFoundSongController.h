//
//  SIBLByFoundSongController.h
//  BiblioPhile
//
//  Created by mac on 6/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "SecondLevelViewController.h"

@interface SIBLByFoundSongController : SecondLevelViewController 
<UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray      *list;
}

- (void) retrieveData;

@property (nonatomic, retain) NSMutableArray *list;

@end
