//
//  MagicQuoteBall.h
//  BiblioPhile
//
//  Created by mac on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define kAccelerationThreshold 1.25
#define kUpdateInterval        (1.0f/10.0f)

#import <UIKit/UIKit.h>

@interface MagicQuoteBall : UIViewController <UIAccelerometerDelegate> {
    UILabel *Hint;
	UILabel *BookTitle;
	UITextView *Quote;
	
	BOOL quoteShowing;
}

- (void) generateRandomQuote;

@property (nonatomic, retain) IBOutlet UILabel *Hint;
@property (nonatomic, retain) IBOutlet UILabel *BookTitle;
@property (nonatomic, retain) IBOutlet UITextView *Quote;

@end
