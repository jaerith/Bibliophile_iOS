//
//  YCQMImageSelection.h
//  BiblioPhile
//
//  Created by mac on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define kMinimumGestureLength 15
#define kMaximumVariance      15

#define kGreenColor  0
#define kWhiteColor  1
#define kRedColor    2
#define kBlueColor   3
#define kYellowColor 4
#define kBlackColor  5

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface YCQMImageSelection : UIViewController 
<UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate> {

	UIImage         *bnLogo;
	UIImage         *snapshotImage;
	NSMutableString *quoteText;
	
	UIImageView *selectedImage;
	UIImageView *logoImage;
	UITextView *selectedQuote;
	
	int     currColorVal;
	CGPoint startPoint;
}

@property (nonatomic, retain) NSMutableString      *quoteText;
@property (nonatomic, retain) UIImage              *snapshotImage;
@property (nonatomic, retain) IBOutlet UIImageView *selectedImage;
@property (nonatomic, retain) IBOutlet UIImageView *logoImage;
@property (nonatomic, retain) IBOutlet UITextView *selectedQuote;

- (IBAction) forwardImage;
- (void) selectExistingPicture;
- (void) switchTextColor;
- (void) saveCurrentScreen;

@end
