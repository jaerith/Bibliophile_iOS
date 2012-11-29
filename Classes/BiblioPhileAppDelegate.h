//
//  BiblioPhileAppDelegate.h
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "FileParser.h"

@class NavViewController;

@interface BiblioPhileAppDelegate : NSObject 
	<UIApplicationDelegate, CLLocationManagerDelegate> {
		
    UIWindow *window;
	UINavigationController *navController;
	
	FileParser *fileParser;
		
	CLLocationManager *locationManager;
	CLLocation        *currLocation;
	NSMutableString   *currLocationDesc;
	NSNumber          *currLatitude;
	NSNumber          *currLongitude;
	
	NSString *currBookTitle;
	
	NSMutableDictionary* myLibraryImages;
	NSMutableDictionary* myLibrarySamples;

	NSMutableDictionary* songsByBook;
	NSMutableDictionary* songsByPerformer;
	
	NSMutableDictionary* bookLocations;
		
	NSMutableDictionary* gamesInspiredByBooks;
		
	NSMutableDictionary* oldCategoryData;
	NSMutableDictionary* newCategoryData;
	
	// NOTE : Probably will not be needed in the near future
	NSArray*                allMediaItems;
	NSMutableDictionary*    allSongsOnIpod;
	NSMutableDictionary*    allSongsLyrics;
	NSOperationQueue*       queueSongOps;
	NSInvocationOperation*  songLookupOp;
	BOOL                    songLookupDone;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@property (nonatomic, retain) FileParser *fileParser;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation        *currLocation;
@property (nonatomic, retain) NSMutableString   *currLocationDesc;
@property (nonatomic, retain) NSNumber          *currLatitude;
@property (nonatomic, retain) NSNumber          *currLongitude;

@property (nonatomic, retain) NSString *currBookTitle;

@property (nonatomic, retain) NSMutableDictionary* myLibraryImages;
@property (nonatomic, retain) NSMutableDictionary* myLibrarySamples;

@property (nonatomic, retain) NSMutableDictionary* songsByBook;
@property (nonatomic, retain) NSMutableDictionary* songsByPerformer;

@property (nonatomic, retain) NSMutableDictionary* bookLocations;

@property (nonatomic, retain) NSMutableDictionary* gamesInspiredByBooks;

@property (nonatomic, retain) NSMutableDictionary* oldCategoryData;
@property (nonatomic, retain) NSMutableDictionary* newCategoryData;

@property (nonatomic, retain) NSArray*               allMediaItems;
@property (nonatomic, retain) NSMutableDictionary*   allSongsOnIpod;
@property (nonatomic, retain) NSMutableDictionary*   allSongsLyrics;
@property (nonatomic, retain) NSOperationQueue*      queueSongOps;
@property (nonatomic, retain) NSInvocationOperation* songLookupOp;

- (void) getAllSongsDataOp;
- (NSMutableDictionary *) getAllSongsCache;
- (BOOL) isSongDataPullDone;
- (void) loadDataFromDisk;
- (void) loadCategorySearchDataFromDisk;
- (void) loadOldCategoryData;
- (void) loadNewCategoryData;
- (void) loadGamesDataFromDisk;
- (void) loadLocationDataFromDisk;
- (void) loadMusicDataFromDisk;
- (void) loadMyLibraryData;
- (NSString *) pathForDataFile;
- (NSString *) pathForGamesDataFile:(NSString*)fileName;
- (NSString *) pathForLocationDataFile:(NSString*)fileName;
- (NSString *) pathForMusicDataFile:(NSString*)fileName;
- (void) saveDataToDisk;
- (void) saveGamesDataToDisk;
- (void) saveLocationDataToDisk;
- (void) saveCuisineLocationDataToDisk;
- (void) savePoliticLocationDataToDisk;
- (void) saveMusicDataToDisk;

@end

