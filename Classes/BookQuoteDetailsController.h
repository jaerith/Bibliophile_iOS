//
//  BookQuoteDetailsController.h
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BookQuoteDetailsController : UIViewController <MFMailComposeViewControllerDelegate> {
    UILabel  *label;
	NSString *message;
}

- (IBAction) forwardQuote;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) NSString *message;

@end
