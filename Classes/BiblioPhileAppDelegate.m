//
//  BiblioPhileAppDelegate.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMediaQuery.h>
#import "BiblioPhileAppDelegate.h"

@implementation BiblioPhileAppDelegate

@synthesize window;
@synthesize navController;

@synthesize locationManager;
@synthesize currLocation;
@synthesize currLocationDesc;
@synthesize currLatitude;
@synthesize currLongitude;

@synthesize fileParser;

@synthesize	currBookTitle;

@synthesize	myLibraryImages;
@synthesize myLibrarySamples;

@synthesize songsByBook;
@synthesize	songsByPerformer;

@synthesize bookLocations;

@synthesize gamesInspiredByBooks;

@synthesize oldCategoryData;
@synthesize newCategoryData;

@synthesize allMediaItems;
@synthesize allSongsOnIpod;
@synthesize allSongsLyrics;
@synthesize queueSongOps;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	self.allSongsOnIpod = [[NSMutableDictionary alloc] init];
	self.allSongsLyrics = [[NSMutableDictionary alloc] init];
	songLookupDone      = FALSE;
	
    self.queueSongOps = [NSOperationQueue new];
    [queueSongOps setMaxConcurrentOperationCount:8];
	
	fileParser = [[FileParser alloc] init];
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];	
		
	myLibraryImages  = [[NSMutableDictionary alloc] init];
	myLibrarySamples = [[NSMutableDictionary alloc] init];
	
	[self loadDataFromDisk];
	[self loadCategorySearchDataFromDisk];
	[self loadGamesDataFromDisk];
	[self loadMyLibraryData];
	[self loadMusicDataFromDisk];
	
	// [self performSelectorInBackground:@selector(findMatchingSongData) withObject:nil];
	
	songLookupOp = 
	    [[NSInvocationOperation alloc] initWithTarget:self  
							           selector:@selector(getAllSongsDataOp) 
									   object:nil];
	
	[songLookupOp setQueuePriority:NSOperationQueuePriorityVeryHigh];
	[queueSongOps addOperation:songLookupOp];
	
	// [fileParser awakeFromNib];
	
	// [self saveGamesDataToDisk];
	// [self saveMusicDataToDisk];
	// [self saveDataToDisk];
	// [self saveLocationDataToDisk];
	// [self saveCuisineLocationDataToDisk];
	// [self savePoliticLocationDataToDisk];
	
    // Override point for customization after application launch
	[window addSubview:navController.view];
    [window makeKeyAndVisible];
}

- (void) getAllSongsDataOp {
	
	@synchronized(self) {
		
		MPMediaQuery *everything = [[MPMediaQuery alloc] init];
	
		NSLog(@"Retrieving items from a generic query...");
	
		self.allMediaItems = [everything items];
		
		for (MPMediaItem *song in self.allMediaItems) {
			
			NSString *songTitle     = [song valueForProperty: MPMediaItemPropertyTitle];
			NSString *performerName = [song valueForProperty: MPMediaItemPropertyArtist];
			NSString *songLyrics    = [song valueForProperty: MPMediaItemPropertyLyrics];
			
			[self.allSongsOnIpod setValue:performerName forKey:songTitle];
			[self.allSongsLyrics setValue:songLyrics forKey:songTitle];
		}
		
		/*
		 for (MPMediaItem *song in itemsFromGenericQuery) {
		 NSString *songTitle     = [song valueForProperty: MPMediaItemPropertyTitle];
		 NSString *performerName = [song valueForProperty: MPMediaItemPropertyArtist];
		 
		 [self.allSongsOnIpod setValue:performerName forKey:songTitle];
		 }
		 
		 NSString *tmpPerformer = [allSongsOnIpod valueForKey:@"To Tame A Land"];
		 NSLog(tmpPerformer);
		 */
	}
	
	songLookupDone = TRUE;
}

- (NSMutableDictionary *) getAllSongsCache {
	
	@synchronized(self) {}
	
	return allSongsOnIpod;
}
	
- (void) loadDataFromDisk
{
	/*
	if (!fileParser.bookData){
		fileParser.bookData = [[NSMutableDictionary alloc] init];
	}
	*/
	
	// NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Books_Subset" ofType:@"dat"];
	// NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Books_Subset" ofType:@"plist"];
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"All_Books" ofType:@"plist"];
    
	// fileParser.bookData = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
	NSLog(dataPath);
	NSDictionary *TempBookData = [NSDictionary dictionaryWithContentsOfFile:dataPath];
	fileParser.bookData = [TempBookData mutableCopy];
	
	/*
	if ([fileParser.bookData count] > 300) {
		
		NSDictionary* TestBookData = [fileParser.bookData valueForKey:@"Watership Down"];
		NSDictionary* TestCharData = [TestBookData valueForKey:@"Characters"];
		NSDictionary* TestQuoteData = [TestBookData valueForKey:@"Quotes"];
		
		NSArray* CharKeys = [TestCharData allKeys];
		NSArray* QuoteKeys = [TestQuoteData allKeys];
		
		NSString* firstCharValue = [TestCharData valueForKey:[CharKeys objectAtIndex:0]];
		NSString* firstQuoteValue = [TestQuoteData valueForKey:[QuoteKeys objectAtIndex:0]];
		
		[firstCharValue release];
		[firstQuoteValue release];
		[CharKeys release];
		[QuoteKeys release];
	}
	*/
}

- (void) loadCategorySearchDataFromDisk {

	if ( oldCategoryData == nil ) {
		
		oldCategoryData = [[NSMutableDictionary alloc] init];
	}
	
	if ( newCategoryData == nil ) {
		
		newCategoryData = [[NSMutableDictionary alloc] init];
	}

	[self loadOldCategoryData];
	
	[self loadNewCategoryData];
}

- (void) loadOldCategoryData {

	// Fourth Level
	NSMutableDictionary *SciFi_OuterSpace_War_DestinedSavior = [[NSMutableDictionary alloc] init];
	NSMutableDictionary	*SciFi_Terrestrial_Future_Dystopia = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_Ancient_Greece_Myths = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_Ancient_Greece_Legends = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_16thCentury_England_Shakespeare = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_19thCentury_Russia_Tolstoy = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_19thCentury_Russia_Dostoyevsky = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_19thCentury_France_Dumas = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_Dystopia_Philosophy_Parable = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_Dystopia_Philosophy_Epic = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_Adventure_England_Animals = [[NSMutableDictionary alloc] init];
	
	// Third Level
	NSMutableDictionary *SciFi_OuterSpace_War = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *SciFi_Terrestrial_Future = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_Ancient_Greece = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_16thCentury_England = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_19thCentury_France = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_19thCentury_Russia = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_Dystopia_Philosophy = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_Adventure_England = [[NSMutableDictionary alloc] init];
	
	// Second Level
	NSMutableDictionary *SciFi_OuterSpace = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *SciFi_Terrestrial = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_Ancient = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_16thCentury = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_19thCentury = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_Adventure = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_Dystopia = [[NSMutableDictionary alloc] init];
	
	// First Level
	NSMutableDictionary *SciFi = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction = [[NSMutableDictionary alloc] init];
	
	[SciFi_OuterSpace_War_DestinedSavior setValue:@"Frank Herbert" forKey:@"Dune"];
	[SciFi_OuterSpace_War_DestinedSavior setValue:@"Orson Scott Card" forKey:@"Enders Game"];
	[SciFi_Terrestrial_Future_Dystopia setValue:@"George Orwell" forKey:@"1984"];
	[ClassicFiction_Ancient_Greece_Myths setValue:@"Edith Hamilton" forKey:@"Mythology"];
	[ClassicFiction_Ancient_Greece_Legends setValue:@"Homer" forKey:@"The Odyssey"];
	[ClassicFiction_16thCentury_England_Shakespeare setValue:@"William Shakespeare" forKey:@"The Tempest"]; 
	[ClassicFiction_19thCentury_Russia_Tolstoy setValue:@"Leo Tolstoy" forKey:@"War and Peace"];
	[ClassicFiction_19thCentury_Russia_Dostoyevsky setValue:@"Fyodor Dostoyevsky" forKey:@"Crime and Punishment"];
	[ClassicFiction_19thCentury_France_Dumas setValue:@"Alexandre Dumas" forKey:@"The Count of Monte Cristo"];
	[ContemporaryFiction_Dystopia_Philosophy_Parable setValue:@"George Orwell" forKey:@"Animal Farm"];
	[ContemporaryFiction_Dystopia_Philosophy_Epic setValue:@"Ayn Rand" forKey:@"Atlas Shrugged"];
	[ContemporaryFiction_Adventure_England_Animals setValue:@"Richard Adams" forKey:@"Watership Down"];
	
	[SciFi_OuterSpace_War setValue:SciFi_OuterSpace_War_DestinedSavior forKey:@"Destined Savior"];
	[SciFi_Terrestrial_Future setValue:SciFi_Terrestrial_Future_Dystopia forKey:@"Dystopia"];
	[ClassicFiction_Ancient_Greece setValue:ClassicFiction_Ancient_Greece_Myths forKey:@"Myths"];
	[ClassicFiction_Ancient_Greece setValue:ClassicFiction_Ancient_Greece_Legends forKey:@"Legends"];
	[ClassicFiction_16thCentury_England setValue:ClassicFiction_16thCentury_England_Shakespeare forKey:@"Shakespeare"]; 
	[ClassicFiction_19thCentury_Russia setValue:ClassicFiction_19thCentury_Russia_Tolstoy forKey:@"Tolstoy"];
	[ClassicFiction_19thCentury_Russia setValue:ClassicFiction_19thCentury_Russia_Dostoyevsky forKey:@"Dostoyevsky"];
	[ClassicFiction_19thCentury_France setValue:ClassicFiction_19thCentury_France_Dumas forKey:@"Dumas"];
	[ContemporaryFiction_Dystopia_Philosophy setValue:ContemporaryFiction_Dystopia_Philosophy_Parable forKey:@"Parable"];
	[ContemporaryFiction_Dystopia_Philosophy setValue:ContemporaryFiction_Dystopia_Philosophy_Epic forKey:@"Epic"];
	[ContemporaryFiction_Adventure_England setValue:ContemporaryFiction_Adventure_England_Animals forKey:@"Animals"];	
	
	[SciFi_OuterSpace setValue:SciFi_OuterSpace_War forKey:@"War"];
	[SciFi_Terrestrial setValue:SciFi_Terrestrial_Future forKey:@"Future"];
	[ClassicFiction_Ancient setValue:ClassicFiction_Ancient_Greece forKey:@"Greece"];
	[ClassicFiction_16thCentury setValue:ClassicFiction_16thCentury_England forKey:@"England"]; 
	[ClassicFiction_19thCentury setValue:ClassicFiction_19thCentury_Russia forKey:@"Russia"];
	[ClassicFiction_19thCentury setValue:ClassicFiction_19thCentury_France forKey:@"France"];
	[ContemporaryFiction_Dystopia setValue:ContemporaryFiction_Dystopia_Philosophy forKey:@"Philosophy"];
	[ContemporaryFiction_Adventure setValue:ContemporaryFiction_Adventure_England forKey:@"England"];	
	
	[SciFi setValue:SciFi_OuterSpace forKey:@"Outer Space"];
	[SciFi setValue:SciFi_Terrestrial forKey:@"Terrestrial"];
	[ClassicFiction setValue:ClassicFiction_Ancient forKey:@"Ancient"];
	[ClassicFiction setValue:ClassicFiction_16thCentury forKey:@"16th Century"]; 
	[ClassicFiction setValue:ClassicFiction_19thCentury forKey:@"19th Century"];
	[ContemporaryFiction setValue:ContemporaryFiction_Dystopia forKey:@"Dystopia"];
	[ContemporaryFiction setValue:ContemporaryFiction_Adventure forKey:@"Adventure"];	
	
	[oldCategoryData setValue:SciFi forKey:@"Science Fiction"];
	[oldCategoryData setValue:ClassicFiction forKey:@"Classic Fiction"];
	[oldCategoryData setValue:ContemporaryFiction forKey:@"Contemporary Fiction"];	
}

- (void) loadNewCategoryData {

	// Fourth Level
	NSMutableDictionary *SciFi_ViolentConflict_DestinedBoyHero_PowerfulVillain = [[NSMutableDictionary alloc] init];
	NSMutableDictionary	*SciFi_StrategicConflict_DestinedBoyHero_FacelessEnemy = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_ViolentConflict_DeityHeroes_DeityVillains = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_ViolentConflict_PerfectWarrior_MythicalVillains = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_VengefulConflict_WizardHero_MischievousVillains = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_ViolentConflict_PerfectWarrior_InfamousVillain = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_PsychologicalConflict_AntiHero_AbstractVillain = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_VengefulConflict_PhoenixHero_TraitorousVillain = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_PhilosophicalConflict_StrongFemaleHero_FascistVillains = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_PhilosophicalConflict_StongMaleHero_FascistVillains = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_PhilosophicalConflict_AnimalHero_AnimalVillain = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_SurvivalConflict_AnimalHero_AnimalVillain = [[NSMutableDictionary alloc] init];
	
	// Third Level
	NSMutableDictionary *SciFi_ViolentConflict_DestinedBoyHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *SciFi_StrategicConflict_DestinedBoyHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_ViolentConflict_DeityHeroes = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_ViolentConflict_PerfectWarrior = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_VengefulConflict_WizardHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_PsychologicalConflict_AntiHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_VengefulConflict_PhoenixHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_PhilosophicalConflict_StrongFemaleHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_PhilosophicalConflict_StongMaleHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_PhilosophicalConflict_AnimalHero = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_SurvivalConflict_AnimalHero = [[NSMutableDictionary alloc] init];
	
	// Second Level
	NSMutableDictionary *SciFi_ViolentConflict = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_ViolentConflict = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_VengefulConflict = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction_PsychologicalConflict = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_PhilosophicalConflict = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction_SurvivalConflict = [[NSMutableDictionary alloc] init];
	
	// First Level
	NSMutableDictionary *SciFi = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ClassicFiction = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *ContemporaryFiction = [[NSMutableDictionary alloc] init];
	
	[SciFi_ViolentConflict_DestinedBoyHero_PowerfulVillain setValue:@"Frank Herbert" forKey:@"Dune"];
	[SciFi_StrategicConflict_DestinedBoyHero_FacelessEnemy setValue:@"Orson Scott Card" forKey:@"Enders Game"];
	[ContemporaryFiction_PhilosophicalConflict_StongMaleHero_FascistVillains setValue:@"George Orwell" forKey:@"1984"];
	[ClassicFiction_ViolentConflict_DeityHeroes_DeityVillains setValue:@"Edith Hamilton" forKey:@"Mythology"];
	[ClassicFiction_ViolentConflict_PerfectWarrior_MythicalVillains setValue:@"Homer" forKey:@"The Odyssey"];
	[ClassicFiction_VengefulConflict_WizardHero_MischievousVillains setValue:@"William Shakespeare" forKey:@"The Tempest"]; 
	[ClassicFiction_PsychologicalConflict_AntiHero_AbstractVillain setValue:@"Fyodor Dostoyevsky" forKey:@"Crime and Punishment"];
	[ClassicFiction_ViolentConflict_PerfectWarrior_InfamousVillain setValue:@"Leo Tolstoy" forKey:@"War and Peace"];
	[ClassicFiction_VengefulConflict_PhoenixHero_TraitorousVillain setValue:@"Alexandre Dumas" forKey:@"The Count of Monte Cristo"];
	[ContemporaryFiction_PhilosophicalConflict_StrongFemaleHero_FascistVillains setValue:@"Ayn Rand" forKey:@"Atlas Shrugged"];
	[ContemporaryFiction_SurvivalConflict_AnimalHero_AnimalVillain setValue:@"Richard Adams" forKey:@"Watership Down"];
	
	[SciFi_ViolentConflict_DestinedBoyHero setValue:SciFi_ViolentConflict_DestinedBoyHero_PowerfulVillain forKey:@"Powerful Villains"];
	[SciFi_StrategicConflict_DestinedBoyHero setValue:SciFi_StrategicConflict_DestinedBoyHero_FacelessEnemy forKey:@"Faceless Masses"];
	[ContemporaryFiction_PhilosophicalConflict_StongMaleHero setValue:ContemporaryFiction_PhilosophicalConflict_StongMaleHero_FascistVillains forKey:@"Fascist Villains"];
	[ClassicFiction_ViolentConflict_DeityHeroes setValue:ClassicFiction_ViolentConflict_DeityHeroes_DeityVillains forKey:@"Deity Villains"];
	[ClassicFiction_ViolentConflict_PerfectWarrior setValue:ClassicFiction_ViolentConflict_PerfectWarrior_MythicalVillains forKey:@"Mythical Villains"];
	[ClassicFiction_VengefulConflict_WizardHero setValue:ClassicFiction_VengefulConflict_WizardHero_MischievousVillains forKey:@"Mischievous Villains"]; 
	[ClassicFiction_PsychologicalConflict_AntiHero setValue:ClassicFiction_PsychologicalConflict_AntiHero_AbstractVillain forKey:@"Abstract Villain"];
	[ClassicFiction_ViolentConflict_PerfectWarrior setValue:ClassicFiction_ViolentConflict_PerfectWarrior_InfamousVillain forKey:@"Infamous Villain"];
	[ClassicFiction_VengefulConflict_PhoenixHero setValue:ClassicFiction_VengefulConflict_PhoenixHero_TraitorousVillain forKey:@"Traitorous Villain"];
	[ContemporaryFiction_PhilosophicalConflict_StrongFemaleHero setValue:ContemporaryFiction_PhilosophicalConflict_StrongFemaleHero_FascistVillains forKey:@"Fascist Villains"];
	[ContemporaryFiction_SurvivalConflict_AnimalHero setValue:ContemporaryFiction_SurvivalConflict_AnimalHero_AnimalVillain forKey:@"Animal Villain"];
	
	[SciFi_ViolentConflict setValue:SciFi_ViolentConflict_DestinedBoyHero forKey:@"Destined Boy Hero"];
	[ContemporaryFiction_PhilosophicalConflict setValue:ContemporaryFiction_PhilosophicalConflict_StongMaleHero forKey:@"Strong Male Hero"];
	[ClassicFiction_ViolentConflict setValue:ClassicFiction_ViolentConflict_DeityHeroes forKey:@"Deity Heroes"];
	[ClassicFiction_ViolentConflict setValue:ClassicFiction_ViolentConflict_PerfectWarrior forKey:@"Perfect Warrior"];
	[ClassicFiction_VengefulConflict setValue:ClassicFiction_VengefulConflict_WizardHero forKey:@"Magical Hero"]; 
	[ClassicFiction_PsychologicalConflict setValue:ClassicFiction_PsychologicalConflict_AntiHero forKey:@"AntiHero"];
	[ClassicFiction_VengefulConflict setValue:ClassicFiction_VengefulConflict_PhoenixHero forKey:@"Phoenix Hero"];
	[ContemporaryFiction_PhilosophicalConflict setValue:ContemporaryFiction_PhilosophicalConflict_StrongFemaleHero forKey:@"Strong Female Hero"];
	[ContemporaryFiction_SurvivalConflict setValue:ContemporaryFiction_SurvivalConflict_AnimalHero forKey:@"Animal Hero"];
	
	[SciFi setValue:SciFi_ViolentConflict forKey:@"Violent Conflict"];
	[ContemporaryFiction setValue:ContemporaryFiction_PhilosophicalConflict forKey:@"Philosophical Conflict"];
	[ClassicFiction setValue:ClassicFiction_ViolentConflict forKey:@"Violent Conflict"];
	[ClassicFiction setValue:ClassicFiction_VengefulConflict forKey:@"Vengeful Conflict"]; 
	[ClassicFiction setValue:ClassicFiction_PsychologicalConflict forKey:@"Psychological Conflict"];
	[ContemporaryFiction setValue:ContemporaryFiction_PhilosophicalConflict forKey:@"Philosophical Conflict"];
	[ContemporaryFiction setValue:ContemporaryFiction_SurvivalConflict forKey:@"Survival Conflict"];
	
	[newCategoryData setValue:SciFi forKey:@"Science Fiction"];
	[newCategoryData setValue:ClassicFiction forKey:@"Classic Fiction"];
	[newCategoryData setValue:ContemporaryFiction forKey:@"Contemporary Fiction"];	
}

- (void) loadGamesDataFromDisk {
	
	NSString* gamesDataPath = [[NSBundle mainBundle] pathForResource:@"GIBL" ofType:@"plist"];
	
	NSLog(gamesDataPath);
	
	NSDictionary *TempGamesData = [NSDictionary dictionaryWithContentsOfFile:gamesDataPath];
	self.gamesInspiredByBooks = [TempGamesData mutableCopy];
}

- (void) loadLocationDataFromDisk {
	NSString* bookLocationsPath = [[NSBundle mainBundle] pathForResource:@"product_location_data" ofType:@"plist"];
	
	NSLog(bookLocationsPath);
	
	NSDictionary *TempLocationData = [NSDictionary dictionaryWithContentsOfFile:bookLocationsPath];
	self.bookLocations = [TempLocationData mutableCopy];
}

- (void) loadMusicDataFromDisk
{
	NSString* songsByBookPath      = [[NSBundle mainBundle] pathForResource:@"SIBL_By_Book" ofType:@"plist"];
    NSString* songsByPerformerPath = [[NSBundle mainBundle] pathForResource:@"SIBL_By_Performer" ofType:@"plist"];
	
	NSLog(songsByBookPath);
	NSLog(songsByPerformerPath);
	
	// NSDictionary *TempBookData = [NSDictionary dictionaryWithContentsOfFile:dataPath];
	// fileParser.bookData = [TempBookData mutableCopy];
	
	NSDictionary *TempByBookData = [NSDictionary dictionaryWithContentsOfFile:songsByBookPath];
	self.songsByBook = [TempByBookData mutableCopy];
	
	NSDictionary *TempByPerformerData = [NSDictionary dictionaryWithContentsOfFile:songsByPerformerPath];
    self.songsByPerformer = [TempByPerformerData mutableCopy];
	
	/*
	// TEST
	NSArray *songsByBookKeys = [songsByBook allKeys];
	
	NSDictionary *DuneSongs = [songsByBook objectForKey:@"Dune"];
	for (id key in DuneSongs) {
		
		NSString* song   = key;
		NSArray*  values = [DuneSongs objectForKey:song];
		int i = 0;
	}
	
	NSDictionary *RushSongs = [songsByPerformer objectForKey:@"Rush"];
	for (id key in RushSongs) {
		
		NSString* song   = key;
		NSArray*  values = [RushSongs objectForKey:song];
		int i = 0;
	}
	*/
}

- (void) loadMyLibraryData {
	
	/*
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	 
	NSString* imagesDirectory  = [NSString stringWithFormat:@"%s/BookCoverImages", documentsDirectory];
	NSString* samplesDirectory = [NSString stringWithFormat:@"%s/SampleChapters", documentsDirectory];
	*/
	
	NSString *folder = @"~";
	folder = [folder stringByExpandingTildeInPath];
	
	/*
	NSString* imagesDirectory  = [folder stringByAppendingPathComponent:@"BookCoverImages"];
    NSString* samplesDirectory = [folder stringByAppendingPathComponent:@"SampleChapters"];
	
	NSLog(imagesDirectory);
	NSLog(samplesDirectory);
	*/
	
	/*
	NSString* tmpFile          = nil;
	// NSString* imagesDirectory  = [[NSBundle mainBundle] pathForResource:@"BookCoverImages" ofType:nil];
    // NSString* samplesDirectory = [[NSBundle mainBundle] pathForResource:@"SampleChapters" ofType:nil];

	NSDirectoryEnumerator* dirImageEnum = [[NSFileManager defaultManager] enumeratorAtPath:imagesDirectory];	
	while (tmpFile = [dirImageEnum nextObject]) {
		
		NSString* imageFile = [NSString stringWithFormat:@"%@/%@", imagesDirectory, tmpFile];
		
		UIImage* tmpImage = [[UIImage alloc] initWithContentsOfFile:imageFile];
		
		NSString* baseName = [imageFile lastPathComponent];
		
		int ExtensionBegins = [baseName length] - 4;
		
		NSString* bookName = [baseName substringToIndex:ExtensionBegins];
		
		[myLibraryImages setValue:tmpImage forKey:bookName];
	}

	NSDirectoryEnumerator* dirSampleEnum = [[NSFileManager defaultManager] enumeratorAtPath:samplesDirectory];	
	while (tmpFile = [dirSampleEnum nextObject]) {
		
		NSString* sampleFile = [NSString stringWithFormat:@"%@/%@", samplesDirectory, tmpFile];
		
		NSString* tmpSample = [[NSString alloc] initWithContentsOfFile:sampleFile];
		
		NSString* baseName = [sampleFile lastPathComponent];
		
		int ExtensionBegins = [baseName length] - 4;
		
		NSString* bookName = [baseName substringToIndex:ExtensionBegins];		
		
		[myLibrarySamples setValue:tmpSample forKey:bookName];
	}
	*/
	
	// OVERRIDE
	UIImage* imageAS  = [UIImage imageNamed:@"Atlas_Shrugged.JPG"];
	UIImage* imageD   = [UIImage imageNamed:@"Dune.JPG"];
	UIImage* imageEG  = [UIImage imageNamed:@"Enders_Game.JPG"];
	UIImage* imageCMC = [UIImage imageNamed:@"The_Count_of_Monte_Cristo.JPG"];
	UIImage* imageWP  = [UIImage imageNamed:@"War_and_Peace.JPG"];
	[myLibraryImages setValue:imageAS forKey:@"Atlas_Shrugged"];
	[myLibraryImages setValue:imageD forKey:@"Dune"];
	[myLibraryImages setValue:imageEG forKey:@"Enders_Game"];
	[myLibraryImages setValue:imageCMC forKey:@"The_Count_of_Monte_Cristo"];
	[myLibraryImages setValue:imageWP forKey:@"War_and_Peace"];	

	NSString* ASText    = [[NSBundle mainBundle] pathForResource:@"Atlas_Shrugged" ofType:@"txt"];
	NSString* sampleAS  = [[NSString alloc] initWithContentsOfFile:ASText];	
	NSString* DText     = [[NSBundle mainBundle] pathForResource:@"Dune" ofType:@"txt"];
	NSString* sampleD   = [[NSString alloc] initWithContentsOfFile:DText];
	NSString* EGText    = [[NSBundle mainBundle] pathForResource:@"Enders_Game" ofType:@"txt"];
	NSString* sampleEG  = [[NSString alloc] initWithContentsOfFile:EGText];
	NSString* CMCText   = [[NSBundle mainBundle] pathForResource:@"The_Count_of_Monte_Cristo" ofType:@"txt"];
	NSString* sampleCMC = [[NSString alloc] initWithContentsOfFile:CMCText];
	NSString* WPText    = [[NSBundle mainBundle] pathForResource:@"War_and_Peace" ofType:@"txt"];
	NSString* sampleWP  = [[NSString alloc] initWithContentsOfFile:WPText];
	[myLibrarySamples setValue:sampleAS forKey:@"Atlas_Shrugged"];
	[myLibrarySamples setValue:sampleD forKey:@"Dune"];
	[myLibrarySamples setValue:sampleEG forKey:@"Enders_Game"];
	[myLibrarySamples setValue:sampleCMC forKey:@"The_Count_of_Monte_Cristo"];
	[myLibrarySamples setValue:sampleWP forKey:@"War_and_Peace"];	
}

- (NSString *) pathForDataFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO) {
		[fileManager createDirectoryAtPath: folder attributes: nil];
	}
    
	// NSString *fileName = @"Books_Subset.dat";
	// NSString *fileName = @"Books_Subset.plist";
	NSString *fileName = @"All_Books.plist";
	return [folder stringByAppendingPathComponent: fileName];
}

- (NSString *) pathForGamesDataFile:(NSString*)fileName {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO) {
		[fileManager createDirectoryAtPath: folder attributes: nil];
	}
    
	return [folder stringByAppendingPathComponent: fileName];
}

- (NSString *) pathForLocationDataFile:(NSString*)fileName {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO) {
		[fileManager createDirectoryAtPath: folder attributes: nil];
	}
    
	return [folder stringByAppendingPathComponent: fileName];
}

- (NSString *) pathForMusicDataFile:(NSString*)fileName {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~";
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO) {
		[fileManager createDirectoryAtPath: folder attributes: nil];
	}
    
	return [folder stringByAppendingPathComponent:fileName];
}

- (void) saveDataToDisk {
	
	NSString * path = [self pathForDataFile];
	    
	// [NSKeyedArchiver archiveRootObject:self.fileParser.bookData toFile:path];
	[self.fileParser.bookData writeToFile:path atomically:YES];
}

- (void) saveGamesDataToDisk {
		
	int      rowCount = 0;
	NSString *tmp;
    NSArray  *lines;
	
	NSMutableDictionary *giblContainer = [[NSMutableDictionary alloc] init];
	
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"GIBL" ofType:@"dat"];
	
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
	
    NSEnumerator *nse = [lines objectEnumerator];
    
    while(tmp = [nse nextObject]) {
		
		if ([tmp length] < 3) {
			rowCount = rowCount + 1;
			continue;
		}
		
		if ((rowCount % 10) == 0) {
			int x = 0;
		}
		
		NSArray *rowData = [tmp componentsSeparatedByString:@"|"];
		
		NSString *GameTitle    = [rowData objectAtIndex:0];
		NSString *Studio       = [rowData objectAtIndex:1];
		NSString *BookTitle    = [rowData objectAtIndex:2];
		NSString *Author       = [rowData objectAtIndex:3];
		
		NSMutableArray *newGameInfo = [[NSMutableArray alloc] init];
		[newGameInfo addObject:Studio];
		[newGameInfo addObject:BookTitle];
		[newGameInfo addObject:Author];
		
		[giblContainer setValue:newGameInfo forKey:GameTitle];
		
		rowCount = rowCount + 1;
	}

	// NOTE : Write to file
	NSString *pathGameData;
	
	pathGameData = [self pathForGamesDataFile:@"GIBL.plist"];
	NSLog(pathGameData);
	[giblContainer writeToFile:pathGameData atomically:YES];	
}

- (void) saveLocationDataToDisk {

	/*
	if (bookLocations == nil) {
		bookLocations = [[NSMutableDictionary alloc] init];
	}
	*/
	
	int      rowCount = 0;
	NSString *tmp;
    NSArray *lines;
	
	NSMutableDictionary *bblUSAtlanticN  = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblUSAtlanticS  = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblUSCentral    = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblUSMountain   = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblUSPacific    = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblAfrica       = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblAsia         = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblAustralia    = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblEuropeEast   = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblEuropeWest   = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblMiddleEast   = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblSouthAmerica = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *bblOther        = [[NSMutableDictionary alloc] init];
	
	//NSString* filePath = [[NSBundle mainBundle] pathForResource:@"product_location_data" ofType:@"txt"];
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"LIB_Master_Index" ofType:@"dat"];

    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
	
    NSEnumerator *nse = [lines objectEnumerator];
    
    while(tmp = [nse nextObject]) {
		
		if ([tmp length] < 3) {
			rowCount = rowCount + 1;
			continue;
		}
		
		NSArray *rowData = [tmp componentsSeparatedByString:@"|"];
		
		// NSString *Ean          = [rowData objectAtIndex:0];
		NSString *Title        = [rowData objectAtIndex:0];
		NSString *Author       = [rowData objectAtIndex:1];
		NSString *Location     = [rowData objectAtIndex:2];
		NSString *LocationDesc = [rowData objectAtIndex:3];
		NSString *Latitude     = [rowData objectAtIndex:4];
		NSString *Longitude    = [rowData objectAtIndex:5];
		
		float fTmpLatitude  = [Latitude floatValue];
		float fTmpLongitude = [Longitude floatValue];
		
		NSNumber *LatitudeNum  = [[NSNumber alloc] initWithFloat:fTmpLatitude];
		NSNumber *LongitudeNum = [[NSNumber alloc] initWithFloat:fTmpLongitude];
		
		NSMutableArray *newBookLocation = [[NSMutableArray alloc] init];
		[newBookLocation addObject:Author];
		[newBookLocation addObject:Location];
		[newBookLocation addObject:LatitudeNum];
		[newBookLocation addObject:LongitudeNum];
		
		if ((fTmpLatitude >= 38.8397f && fTmpLatitude <= 59.3555f) && 
			(fTmpLongitude >= -85.7373f) && (fTmpLongitude <= -50.625f)) {
			
			[bblUSAtlanticN setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= 14.5197f && fTmpLatitude <= 38.8397f) && 
			(fTmpLongitude >= -85.7373f) && (fTmpLongitude <= -50.625f)) {
			
			[bblUSAtlanticS setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= 14.9447f && fTmpLatitude <= 59.3555f) && 
				 (fTmpLongitude >= -102.3046f) && (fTmpLongitude <= -85.7374f)) {
			
			[bblUSCentral setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= 14.9447f && fTmpLatitude <= 59.3555f) && 
				 (fTmpLongitude >= -114.0820f) && (fTmpLongitude <= -102.3046f)) {
			
			[bblUSMountain setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= 14.9447f && fTmpLatitude <= 59.3555f) && 
				 (fTmpLongitude >= -128.3203f) && (fTmpLongitude <= -114.0821f)) {
			
			[bblUSPacific setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= -36.5978f && fTmpLatitude <= 35.1739f) && 
				 (fTmpLongitude >= -17.2266f) && (fTmpLongitude <= 33.4863f)) {
			
			[bblAfrica setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= -5.2660f && fTmpLatitude <= 103.7109f) && 
				 (fTmpLongitude >= 62.2266f) && (fTmpLongitude <= 180.0000f)) {
			
			[bblAsia setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= -43.8345f && fTmpLatitude <= -11.1784f) && 
				 (fTmpLongitude >= 112.1484f) && (fTmpLongitude <= 154.6875f)) {
			
			[bblAustralia setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= 36.7037f && fTmpLatitude <= 71.1878f) && 
				 (fTmpLongitude >= 13.5351f) && (fTmpLongitude <= 38.3203f)) {
			
			[bblEuropeEast setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= 36.7037f && fTmpLatitude <= 71.1878f) && 
				 (fTmpLongitude >= -10.1074f) && (fTmpLongitude <= 13.5351f)) {
			
			[bblEuropeWest setValue:newBookLocation forKey:Title];
		}		
		else if ((fTmpLatitude >= 12.6403f && fTmpLatitude <= 47.6367f) && 
				 (fTmpLongitude >= 34.2333f) && (fTmpLongitude <= 60.9301f)) {
			
			[bblMiddleEast setValue:newBookLocation forKey:Title];
		}
		else if ((fTmpLatitude >= -82.9688f && fTmpLatitude <= -34.4531f) && 
				 (fTmpLongitude >= -69.6093f) && (fTmpLongitude <= -55.9737f)) {
			
			[bblSouthAmerica setValue:newBookLocation forKey:Title];
		}
		else {
			[bblOther setValue:newBookLocation forKey:Title];
		}
    }

	/*
	[mapRegionToFile setValue:@"BBL_US_Atlantic" forKey:@"In U.S. (Atlantic)"];
	[mapRegionToFile setValue:@"BBL_US_Central" forKey:@"In U.S. (Central)"];
	[mapRegionToFile setValue:@"BBL_US_Mountain" forKey:@"In U.S. (Mountain)"];
	[mapRegionToFile setValue:@"BBL_US_Pacific" forKey:@"In U.S. (Pacific)"];
	[mapRegionToFile setValue:@"BBL_Africa" forKey:@"In Africa"];
	[mapRegionToFile setValue:@"BBL_Asia" forKey:@"In Asia"];
	[mapRegionToFile setValue:@"BBL_Australia" forKey:@"In Australia"];
	[mapRegionToFile setValue:@"BBL_Europe" forKey:@"In Europe"];
	[mapRegionToFile setValue:@"BBL_Middle_East" forKey:@"In Middle East"];
	[mapRegionToFile setValue:@"BBL_South America" forKey:@"In South America"];	
	[mapRegionToFile setValue:@"BBL_Other" forKey:@"Other"];
	*/
	
	// NOTE : Write to files
	NSString *pathLocationData;
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_US_Atlantic_North.plist"];
	NSLog(pathLocationData);
	[bblUSAtlanticN writeToFile:pathLocationData atomically:YES];
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_US_Atlantic_South.plist"];
	NSLog(pathLocationData);
	[bblUSAtlanticS writeToFile:pathLocationData atomically:YES];	
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_US_Central.plist"];
	NSLog(pathLocationData);
	[bblUSCentral writeToFile:pathLocationData atomically:YES];	
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_US_Mountain.plist"];
	NSLog(pathLocationData);
	[bblUSMountain writeToFile:pathLocationData atomically:YES];
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_US_Pacific.plist"];
	NSLog(pathLocationData);
	[bblUSPacific writeToFile:pathLocationData atomically:YES];	
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_Africa.plist"];
	NSLog(pathLocationData);
	[bblAfrica writeToFile:pathLocationData atomically:YES];		
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_Asia.plist"];
	NSLog(pathLocationData);
	[bblAsia writeToFile:pathLocationData atomically:YES];	

	pathLocationData = [self pathForLocationDataFile:@"BBL_Australia.plist"];
	NSLog(pathLocationData);
	[bblAustralia writeToFile:pathLocationData atomically:YES];
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_Europe_East.plist"];
	NSLog(pathLocationData);
	[bblEuropeEast writeToFile:pathLocationData atomically:YES];

	pathLocationData = [self pathForLocationDataFile:@"BBL_Europe_West.plist"];
	NSLog(pathLocationData);
	[bblEuropeWest writeToFile:pathLocationData atomically:YES];
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_Middle_East.plist"];
	NSLog(pathLocationData);
	[bblMiddleEast writeToFile:pathLocationData atomically:YES];
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_South_America.plist"];
	NSLog(pathLocationData);
	[bblSouthAmerica writeToFile:pathLocationData atomically:YES];
	
	pathLocationData = [self pathForLocationDataFile:@"BBL_Other.plist"];
	NSLog(pathLocationData);
	[bblOther writeToFile:pathLocationData atomically:YES];	
	
	// Release collections
	[bblUSAtlanticN release];
	[bblUSAtlanticS release];
	[bblUSCentral release];
	[bblUSMountain release];
	[bblUSPacific release];
	[bblAfrica release];
	[bblAsia release];
	[bblAustralia release];
	[bblEuropeEast release];
	[bblEuropeWest release];
	[bblMiddleEast release];
	[bblSouthAmerica release];
	[bblOther release];
}

- (void) saveCuisineLocationDataToDisk {
	
	int      rowCount = 0;
	NSString *tmp;
    NSArray *lines;	
	
	NSMutableDictionary *bblcData = [[NSMutableDictionary alloc] init];
	
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"sample.geo-cuisine" ofType:@"dat"];
	
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
	
    NSEnumerator *nse = [lines objectEnumerator];
    
    while(tmp = [nse nextObject]) {
		
		if ([tmp length] < 3) {
			rowCount = rowCount + 1;
			continue;
		}
		
		if ((rowCount % 10) == 0) {
			int x = 0;
		}
		
		NSArray *rowData = [tmp componentsSeparatedByString:@"|"];
		
		NSString *Title        = [rowData objectAtIndex:0];
		NSString *Author       = [rowData objectAtIndex:1];
		NSString *Category     = [rowData objectAtIndex:2];
		NSString *Location     = [rowData objectAtIndex:3];
		NSString *Latitude     = [rowData objectAtIndex:4];
		NSString *Longitude    = [rowData objectAtIndex:5];
		
		float fTmpLatitude  = [Latitude floatValue];
		float fTmpLongitude = [Longitude floatValue];
		
		NSNumber *LatitudeNum  = [[NSNumber alloc] initWithFloat:fTmpLatitude];
		NSNumber *LongitudeNum = [[NSNumber alloc] initWithFloat:fTmpLongitude];
		
		NSMutableArray *newCuisineBookLocation = [[NSMutableArray alloc] init];
		[newCuisineBookLocation addObject:Author];
		[newCuisineBookLocation addObject:Location];
		[newCuisineBookLocation addObject:LatitudeNum];
		[newCuisineBookLocation addObject:LongitudeNum];
		
		[bblcData setValue:newCuisineBookLocation forKey:Title];
		
		rowCount = rowCount + 1;
	}
	
	NSString *pathLocationData = [self pathForLocationDataFile:@"CBBL_Sample.plist"];
	NSLog(pathLocationData);
	[bblcData writeToFile:pathLocationData atomically:YES];	
}

- (void) savePoliticLocationDataToDisk {
	
	int      rowCount = 0;
	NSString *tmp;
    NSArray *lines;	
	
	NSMutableDictionary *bblpData = [[NSMutableDictionary alloc] init];
	
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"sample.geo-political" ofType:@"dat"];
	
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
	
    NSEnumerator *nse = [lines objectEnumerator];
    
    while(tmp = [nse nextObject]) {
		
		if ([tmp length] < 3) {
			rowCount = rowCount + 1;
			continue;
		}
		
		if ((rowCount % 10) == 0) {
			int x = 0;
		}
		
		NSArray *rowData = [tmp componentsSeparatedByString:@"|"];
		
		NSString *Title        = [rowData objectAtIndex:0];
		NSString *Author       = [rowData objectAtIndex:1];
		NSString *Category     = [rowData objectAtIndex:2];
		NSString *Location     = [rowData objectAtIndex:3];
		NSString *Latitude     = [rowData objectAtIndex:4];
		NSString *Longitude    = [rowData objectAtIndex:5];
		
		float fTmpLatitude  = [Latitude floatValue];
		float fTmpLongitude = [Longitude floatValue];
		
		NSNumber *LatitudeNum  = [[NSNumber alloc] initWithFloat:fTmpLatitude];
		NSNumber *LongitudeNum = [[NSNumber alloc] initWithFloat:fTmpLongitude];
		
		NSMutableArray *newPoliticalBookLocation = [[NSMutableArray alloc] init];
		[newPoliticalBookLocation addObject:Author];
		[newPoliticalBookLocation addObject:Location];
		[newPoliticalBookLocation addObject:LatitudeNum];
		[newPoliticalBookLocation addObject:LongitudeNum];
		
		[bblpData setValue:newPoliticalBookLocation forKey:Title];
		
		rowCount = rowCount + 1;
	}
	
	NSString *pathLocationData = [self pathForLocationDataFile:@"PBBL_Sample.plist"];
	NSLog(pathLocationData);
	[bblpData writeToFile:pathLocationData atomically:YES];	
}

- (void) saveMusicDataToDisk {
	
	songsByBook      = [[NSMutableDictionary alloc] init];
	songsByPerformer = [[NSMutableDictionary alloc] init];
	
	int      rowCount = 0;
	NSString *tmp;
    NSArray *lines;
	
	// NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SIBL" ofType:@"dat"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"SIBL.001" ofType:@"dat"];	
	
    lines = [[NSString stringWithContentsOfFile:filePath] componentsSeparatedByString:@"\n"];
//			  stringByStandardizingPath] 
    
    NSEnumerator *nse = [lines objectEnumerator];
    
    while(tmp = [nse nextObject]) {

		if ((rowCount == 0) || ([tmp length] < 3)) {
			rowCount = rowCount + 1;
			continue;
		}
		
		if ((rowCount % 20) == 0) {
			int x = 1;
		}
				
		NSArray *rowData = [tmp componentsSeparatedByString:@"|"];

		NSString *songWriter = [rowData objectAtIndex:0];
		NSString *song       = [rowData objectAtIndex:1];
		NSString *performer  = [rowData objectAtIndex:2];
		NSString *album      = [rowData objectAtIndex:3];
		NSString *book       = [[rowData objectAtIndex:4]
							       stringByTrimmingCharactersInSet:[NSCharacterSet 
									   characterSetWithCharactersInString:@"\""]];
		NSString *author     = [[rowData objectAtIndex:5]
							       stringByTrimmingCharactersInSet:[NSCharacterSet 
								       characterSetWithCharactersInString:@"\r"]];
		
		if ([performer isEqualToString:@"Tori Amos"]) {
			int x = 1;
		}
		
		if ([songsByBook objectForKey:book] == nil) {
			
			NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
			
			[songsByBook setValue:tmpDictionary forKey:book];
			
			// [tmpDictionary release];
		}
		
		if ([songsByPerformer objectForKey:performer] == nil) {
			NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
			
			[songsByPerformer setValue:tmpDictionary forKey:performer];
			
			// [tmpDictionary release];
		}
		
		if ( [song isEqualToString:@"Entire Album"] || [song isEqualToString:@"Whole Album"] ) {
			song = album;
		}
		
		NSMutableDictionary *ByBookEntry      = [songsByBook objectForKey:book];
		NSMutableDictionary *ByPerformerEntry = [songsByPerformer objectForKey:performer];

		NSMutableArray* bookValues      = [[NSMutableArray alloc] init];
		NSMutableArray* performerValues = [[NSMutableArray alloc] init];

		[bookValues addObject:author];
		[bookValues addObject:song];
		[bookValues addObject:performer];
		
		[performerValues addObject:song];
		[performerValues addObject:author];
		[performerValues addObject:book];
		
		[ByBookEntry setValue:bookValues forKey:song];
		[ByPerformerEntry setValue:performerValues forKey:song];
		
		/*		 
        NSString *stringBetweenBrackets = nil;
        NSScanner *scanner = [NSScanner scannerWithString:tmp];

        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&stringBetweenBrackets];
		
        NSLog([stringBetweenBrackets description]);
		*/
		
		rowCount = rowCount + 1;
		
		// [bookValues release];
		// [performerValues release];
		// [rowData release];
    }

	// TEST
	NSArray *songsByBookKeys = [songsByBook allKeys];

	NSDictionary *DuneSongs = [songsByBook objectForKey:@"Dune"];
	for (id key in DuneSongs) {
		
		NSString* song   = key;
		NSArray*  values = [DuneSongs objectForKey:song];
	}
	
	NSDictionary *RushSongs = [songsByPerformer objectForKey:@"Rush"];
	for (id key in DuneSongs) {
		
		NSString* song   = key;
		NSArray*  values = [RushSongs objectForKey:song];
	}		

	// NOTE : Write to files
	NSString *pathByBook = [self pathForMusicDataFile:@"SIBL_By_Book.plist"];
	NSLog(pathByBook);
	[self.songsByBook writeToFile:pathByBook atomically:YES];
		
	NSString *pathByPerformer = [self pathForMusicDataFile:@"SIBL_By_Performer.plist"];
	NSLog(pathByPerformer);
	[self.songsByPerformer writeToFile:pathByPerformer atomically:YES];
}

- (void)dealloc {
	[locationManager release];
	[currLocation release];
	[navController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager*) manager
	didUpdateToLocation:(CLLocation*) newLocation
		   fromLocation:(CLLocation*) oldLocation {
	
	if (currLocation == nil) {
				
		currLocation = newLocation;
		
		NSString *tmpLogMsg = 
			[NSString stringWithFormat:@"Location: %@", [currLocation description]];
		NSLog(tmpLogMsg);
		
		/*
		printf("\n Latitude = %s\n Longitude = %s \n",
			   [NSString stringWithFormat:@"%.4f",currLocation.coordinate.latitude],
			   [NSString stringWithFormat:@"%.4f",currLocation.coordinate.longitude]);
		*/
		
		NSMutableString *tmpLocationDesc = [[currLocation description] mutableCopy];
				
		[tmpLocationDesc replaceOccurrencesOfString:@"<" withString:@"|" 
											 options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tmpLocationDesc length])];
		[tmpLocationDesc replaceOccurrencesOfString:@">" withString:@"|" 
											 options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tmpLocationDesc length])];
		
		NSArray *locData = [tmpLocationDesc componentsSeparatedByString:@"|"];
		
		NSMutableString *coordinatesDesc = [[locData objectAtIndex:1] mutableCopy];
		
		NSArray *coordinates = [coordinatesDesc componentsSeparatedByString:@","];
		
		NSString *latitude = [coordinates objectAtIndex:0];
		NSString *longitude = [coordinates objectAtIndex:1];
		
		NSString* FormattedLocDesc = 
			[NSString stringWithFormat:@"%@,%@", 
				[latitude substringToIndex:6], [longitude substringToIndex:8]];
		
		self.currLocationDesc = [FormattedLocDesc mutableCopy];		
		
		self.currLatitude  = [[NSNumber alloc] initWithFloat:[latitude floatValue]];
		self.currLongitude = [[NSNumber alloc] initWithFloat:[longitude floatValue]];
		
		[self.locationManager stopUpdatingLocation];
		
		[coordinatesDesc release];
		[tmpLocationDesc release];
	}
}

- (void) locationManager:(CLLocationManager*) manager
		didFailWithError:(NSError*) error {
	
	NSString *errorType = 
	(error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	
	NSString* errMsg = 
	[NSString stringWithFormat:@"%@. Defaulting to coordinates (40.7409, -74.0024)", errorType];
	
	UIAlertView *alert = 
	[[UIAlertView alloc] initWithTitle:@"Error getting Location" 
							   message:errMsg delegate:nil 
					 cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	
	[alert show];
	
	self.currLocationDesc = @"40.74, -74.00";

	float fTmpLatitude = 40.7409f;
	self.currLatitude = [[NSNumber alloc] initWithFloat:fTmpLatitude];
	
	float fTmpLongitude = -74.0024f;
	self.currLongitude = [[NSNumber alloc] initWithFloat:fTmpLongitude];
	
	[alert release];
}

- (BOOL) isSongDataPullDone {
	
	return songLookupDone;
}

@end
