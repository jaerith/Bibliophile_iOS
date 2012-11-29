//
//  BookSearchGenericController.h
//  BiblioPhile
//
//  Created by mac on 7/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCol1Component 0
#define kCol2Component 1
#define kCol3Component 2
#define kCol4Component 3

@interface BookSearchGenericController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate> {

	UIImageView *column1Image;
	UIImageView *column2Image;
	UIImageView *column3Image;
	UIImageView *column4Image;

	UIPickerView *categoryPicker;
	
	UITextView *categoryPickerReport;

	UIButton *spinButton;
	UIButton *resetButton;
	UIButton *searchButton;
	
	NSMutableDictionary *allCategoryData;
	
	NSArray *column1List;
	NSArray *column2List;
	NSArray *column3List;
	NSArray *column4List;
	
	NSMutableArray *currSelectedPath;
	
	NSDictionary *currSearchData;
}

-(id)initWithTabBar:(NSString*)viewType;

- (IBAction) spin;
- (IBAction) reset;
- (IBAction) search;

- (void) updateCategoryReport:(NSString*) subCategory;

@property (nonatomic, retain) IBOutlet UIImageView *column1Image;
@property (nonatomic, retain) IBOutlet UIImageView *column2Image;
@property (nonatomic, retain) IBOutlet UIImageView *column3Image;
@property (nonatomic, retain) IBOutlet UIImageView *column4Image;

@property (nonatomic, retain) IBOutlet UIPickerView *categoryPicker;

@property (nonatomic, retain) IBOutlet UITextView *categoryPickerReport;

@property (nonatomic, retain) IBOutlet UIButton *spinButton;
@property (nonatomic, retain) IBOutlet UIButton *resetButton;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

@property (nonatomic, retain) NSMutableDictionary *allCategoryData;

@property (nonatomic, retain) NSArray *column1List;
@property (nonatomic, retain) NSArray *column2List;
@property (nonatomic, retain) NSArray *column3List;
@property (nonatomic, retain) NSArray *column4List;

@property (nonatomic, retain) NSMutableArray *currSelectedPath;

@end
