//
//  YCQMImageSelection.m
//  BiblioPhile
//
//  Created by mac on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

#import "BiblioPhileAppDelegate.h"
#import "YCQMImageSelection.h"

@implementation YCQMImageSelection

@synthesize quoteText;
@synthesize snapshotImage;
@synthesize selectedImage;
@synthesize logoImage;
@synthesize selectedQuote;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    if (self = [super initWithNibName:@"YCQMImageSelection" bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	bnLogo = [UIImage imageNamed:@"bn_logo_small.gif"];
	
	// Email button
	UIBarButtonItem *emailButton = 
	    [[UIBarButtonItem alloc] initWithTitle:@"Email" 
									style:UIBarButtonItemStyleBordered 
									target:self 
									action:@selector(forwardImage)];
	
	// Just in case
	if ([MFMailComposeViewController canSendMail])
	    emailButton.enabled = YES;
	
	self.navigationItem.rightBarButtonItem = emailButton;
	
	[emailButton release];
	
    // Text
	currColorVal = kGreenColor;
	selectedQuote.textColor = [UIColor greenColor];
	selectedQuote.font = [UIFont boldSystemFontOfSize:10];
	selectedQuote.text = quoteText;
	
	[self selectExistingPicture];
	
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[bnLogo release];
	[quoteText release];
    [super dealloc];
}

#pragma mark -
- (void) selectExistingPicture {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		
		UIImagePickerController *imagePickerController = 
			[[UIImagePickerController alloc] init];
		
		imagePickerController.delegate = self;
		
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:imagePickerController animated:YES];
				
		[imagePickerController release];
	}
	else{
		
		UIAlertView *alert = 
			[[UIAlertView alloc] initWithTitle:@"Error accessing photo library" 
				message:@"Device does not support a photo library" 
					delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[alert show];
		
		[alert release];
	}
}

- (void) saveCurrentScreen {
	
	// Save the current screen
	CGRect targetImageRect = 
		CGRectMake(0.0, 200.0, selectedImage.bounds.size.width, selectedImage.bounds.size.height + 75);
	
	// UIGraphicsBeginImageContext(selectedImage.bounds.size);
	UIGraphicsBeginImageContext(targetImageRect.size);
	[selectedImage.window.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

	/*
	// Before finishing the save, be sure to crop it
	CGRect cropRect = CGRectZero;
	cropRect.origin = ;
	cropRect.origin.x = cropRect.origin.x + 100;
	cropRect.size.width  = scaledWidth;
	cropRect.size.height = scaledHeight;
	
	CGRect cropImageRect = 
		CGRectMake(0.0, 100.0, targetImageRect.size.width, targetImageRect.size.height - 100);
	
	[viewImage drawInRect:cropImageRect];
	
	UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
	if(cropImage == nil) 
        NSLog(@"could not scale image");
	*/
	
	UIGraphicsEndImageContext();

	/*
	CGImageRef cropImageRef = 
		CGImageCreateWithImageInRect([viewImage CGImage], 
			CGRectMake(0, 50, targetImageRect.size.width, targetImageRect.size.height - 25));
	
	UIImage *cropImage = [UIImage imageWithCGImage:cropImageRef];
	*/
	
	UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
	// UIImageWriteToSavedPhotosAlbum(cropImage, nil, nil, nil);
	
	self.snapshotImage = viewImage;
	
	// Play audio to signal the user that the save was successful
	NSString *audioFile = 
	    [[NSBundle mainBundle] pathForResource:@"camera1" ofType:@"wav"];
	
	SystemSoundID soundID;
	
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:audioFile], 
									 &soundID);
	
	AudioServicesPlaySystemSound(soundID);
}

- (void) switchTextColor {
	
	if (currColorVal == kGreenColor) {
		currColorVal = kWhiteColor;
		selectedQuote.textColor = [UIColor whiteColor];
	}
	else if (currColorVal == kWhiteColor) {
		currColorVal = kRedColor;
		selectedQuote.textColor = [UIColor redColor];
	}
	else if (currColorVal == kRedColor) {
		currColorVal = kBlueColor;
		selectedQuote.textColor = [UIColor blueColor];
	}
	else if (currColorVal == kBlueColor) {
		currColorVal = kYellowColor;
		selectedQuote.textColor = [UIColor yellowColor];
	}
	else if (currColorVal == kYellowColor) {
		currColorVal = kBlackColor;
		selectedQuote.textColor = [UIColor blackColor];
	}
	else if (currColorVal == kBlackColor) {
		currColorVal = kGreenColor;
		selectedQuote.textColor = [UIColor greenColor];
	}
	
	[self.view setNeedsDisplay];	
}

- (IBAction) forwardImage {
	
	BiblioPhileAppDelegate *delegate = 
	    (BiblioPhileAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	// First, we're saving the picture onto the iPhone
    [self saveCurrentScreen];

	// Next, we will offer to mail the image
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	
	NSString *emailBody =
	    [NSString stringWithFormat:@"%@\n\n\n\nPresented by bibliofile.net", quoteText];
	
	controller.mailComposeDelegate = self;
	[controller setSubject:@"Check Out This Image"];
	[controller setMessageBody:emailBody isHTML:NO];
	
	// Now, attach the attachment
	NSData *screenshotPNG = UIImagePNGRepresentation(self.snapshotImage);	
	[controller addAttachmentData:screenshotPNG mimeType:@"image/png" fileName:@"MyQuotedPicture"];
	
	// Now, present the email
	[self presentModalViewController:controller animated:YES];
	[controller release];	
}

#pragma mark -
- (void) imagePickerController:(UIImagePickerController*) picker
	didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo {
	
	selectedImage.image = image;
	logoImage.image = bnLogo;
	
	/*
	float fX = image.size.width - bnLogo.size.width;
	float fY = image.size.height - bnLogo.size.height;
	
	CGPoint logoPoint = CGPointMake(fX, fY);
	[bnLogo drawAtPoint:logoPoint];
	*/
	
	[picker dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*) picker {
	
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {

	UITouch *touch = [touches anyObject];
	
	NSUInteger tapCount = [touch tapCount];
	CGPoint tmpPoint = [touch locationInView:self.view];
	
	startPoint = tmpPoint;
	
	switch (tapCount) {
			
		case 1:
			[self performSelector:@selector(saveCurrentScreen) withObject:nil afterDelay:0.4];
			break;
		case 2:
			[NSObject cancelPreviousPerformRequestsWithTarget:self
				selector:@selector(saveCurrentScreen) object:nil];
			
			[self performSelector:@selector(switchTextColor) withObject:nil afterDelay:0.4];
			break;			
	}
	
	// [self saveCurrentScreen];	
}

/*
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {

	UITouch *touch = [touches anyObject];
	
	CGPoint currPoint = [touch locationInView:self.view];
	
	CGFloat deltaX = fabsf(startPoint.x - currPoint.x);
	CGFloat deltaY = fabsf(startPoint.y - currPoint.y);	
	
	if ((deltaX >= kMinimumGestureLength) && (deltaY <= kMaximumVariance)) {
		
		if (currColorVal == kGreenColor) {
			currColorVal = kWhiteColor;
			selectedQuote.textColor = [UIColor whiteColor];
		}
		else if (currColorVal == kWhiteColor) {
			currColorVal = kRedColor;
			selectedQuote.textColor = [UIColor redColor];
		}
		else if (currColorVal == kRedColor) {
			currColorVal = kBlueColor;
			selectedQuote.textColor = [UIColor blueColor];
		}
		else if (currColorVal == kBlueColor) {
			currColorVal = kYellowColor;
			selectedQuote.textColor = [UIColor yellowColor];
		}
		else if (currColorVal == kYellowColor) {
			currColorVal = kBlackColor;
			selectedQuote.textColor = [UIColor blackColor];
		}
		else if (currColorVal == kBlackColor) {
			currColorVal = kGreenColor;
			selectedQuote.textColor = [UIColor greenColor];
		}		
	}
}
*/

/*
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	
	UITouch *touch = [touches anyObject];
	
	CGPoint endPoint = [touch locationInView:self.view];

	CGFloat deltaX = fabsf(startPoint.x - endPoint.x);
	CGFloat deltaY = fabsf(startPoint.y - endPoint.y);	
	
	if ((deltaX <= 5.0) && (deltaY <= 5.0)) {
				
	    [self saveCurrentScreen];
	}
	if ((deltaX >= kMinimumGestureLength) && (deltaY <= kMaximumVariance)) {
		
		if (currColorVal == kGreenColor) {
			currColorVal = kWhiteColor;
			selectedQuote.textColor = [UIColor whiteColor];
		}
		else if (currColorVal == kWhiteColor) {
			currColorVal = kRedColor;
			selectedQuote.textColor = [UIColor redColor];
		}
		else if (currColorVal == kRedColor) {
			currColorVal = kBlueColor;
			selectedQuote.textColor = [UIColor blueColor];
		}
		else if (currColorVal == kBlueColor) {
			currColorVal = kYellowColor;
			selectedQuote.textColor = [UIColor yellowColor];
		}
		else if (currColorVal == kYellowColor) {
			currColorVal = kBlackColor;
			selectedQuote.textColor = [UIColor blackColor];
		}
		else if (currColorVal == kBlackColor) {
			currColorVal = kGreenColor;
			selectedQuote.textColor = [UIColor greenColor];
		}
		
		[self.view setNeedsDisplay];
	}
}
*/

#pragma mark -
#pragma mark -
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

@end
