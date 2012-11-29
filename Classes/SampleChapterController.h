//
//  SampleChapterController.h
//  BiblioPhile
//
//  Created by mac on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SampleChapterController : UIViewController {
	UITextView *textView;
	NSString *message;
}

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSString *message;

@end
