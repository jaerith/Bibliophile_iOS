//
//  FileParser.m
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FileParser.h"

@implementation FileParser

@synthesize bookData;
@synthesize musicData;

- (id) init {
	self = [super init];
	if (self != nil) {
	}
	
	if (!bookData){
		bookData = [[NSMutableDictionary alloc] init];
	}	
	
	return self;
}

-(void)awakeFromNib{
	
	if (!bookData){
		bookData = [[NSMutableDictionary alloc] init];
	}
	
	//NSString* bookXmlFile = [[NSBundle mainBundle] pathForResource:@"Books_Subset" ofType:@"xml"];
	NSString* bookXmlFile = [[NSBundle mainBundle] pathForResource:@"Books.MoreQuotes" ofType:@"xml"];
	
	[self parseXMLFile:bookXmlFile];
	
	/*
	 ** NOTE : OLD WAY
	int       bookCount    = 0;
	NSString* tmpXmlFile   = nil;
	NSString* xmlDirectory = [[NSBundle mainBundle] pathForResource:@"characters" ofType:nil];
	
	NSDirectoryEnumerator* dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:xmlDirectory];
	
	while (tmpXmlFile = [dirEnum nextObject]) {
		
		if (((bookCount % 75) == 0) || ([tmpXmlFile isEqualToString:@"Dune.xml"]) || ([tmpXmlFile isEqualToString:@"Atlas_Shrugged.xml"])) {

   		    NSString* formatXmlFile = [NSString stringWithFormat:@"characters/%@", tmpXmlFile];
	        //NSString* bookXmlFile = [[NSBundle mainBundle] pathForResource:formatXmlFile ofType:@"xml"];
		    NSString* bookXmlFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:formatXmlFile];
		
		    [self parseXMLFile:bookXmlFile];
id`			
		    // [tmpXmlFile release];
		    // [formatXmlFile release];
		    // [bookXmlFile release];
		}
		
		bookCount = bookCount + 1;
		
		//if ((bookCount % 10) == 0) {
		//	int x = 1;
		//}
		
		//if (bookCount == 3)
		//	break;
		//
    }
	 
	// [dirEnum release];
	// [xmlDirectory release];
	*/
	
	if ([bookData count] > 300) {
		NSDictionary* TestBookData = [bookData valueForKey:@"Watership Down"];
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
}

- (void) parseXMLFile:(NSString*) pathToFile {
	BOOL success;
	
    NSURL *xmlURL = [NSURL fileURLWithPath:pathToFile];
    
	bookDataParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [bookDataParser setDelegate:self];
    [bookDataParser setShouldResolveExternalEntities:YES];
    
	success = [bookDataParser parse]; // return value not used
	// if not successful, delegate is informed of error
	NSLog(@"parsed!");
	
	[bookDataParser release];
	//[xmlURL release];
	
	bookDataParser = nil;
	// xmlURL = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{
	if ( [elementName isEqualToString:@"Product"]) {
	    NSLog(@"found product");
		insideProduct = YES;
				
		if (!tmpBookTitle){
			tmpBookTitle = [[NSMutableDictionary alloc] init];
		}
		
		if (!tmpBookData){
			tmpBookData = [[NSMutableDictionary alloc] init];
        }
		
		if (!tmpBookCharData) {
			tmpBookCharData = [[NSMutableDictionary alloc] init];
		}
		
		if (!tmpBookQuoteData) {
			tmpBookQuoteData = [[NSMutableDictionary alloc] init];
		}		
    }		
	
	if ( [elementName isEqualToString:@"Character"]) {
	    NSLog(@"found character");
		insideChar = YES;
		
		/*
		// addresses is an NSMutableArray instance variable
		if (!addresses)
			addresses = [[NSMutableArray alloc] init];
		*/
		
        return;
    }
	
	if ( [elementName isEqualToString:@"Quote"] ) {
		NSLog(@"found Quote");
		insideQuote = YES;
		
		/*
        // currentPerson is an ABPerson instance variable
        currentPerson = [[ABPerson alloc] init];
		*/
		
        return;
    }

	/*
	if ( [elementName isEqualToString:@"lastName"] ) {
		NSLog(@"found lastName");
        // currentPerson is an ABPerson instance variable
        currentPerson = [[ABPerson alloc] init];
        return;
    }
	*/
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSLog(@"found characters:%@",string);
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] init];
    }
	NSLog(@"appendingstring...");
    [currentStringValue appendString:[string 
									  stringByTrimmingCharactersInSet:[NSCharacterSet 
																	   whitespaceAndNewlineCharacterSet]]];
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString {
	[whitespaceString release];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
	if ([elementName isEqualToString:@"Product"]) {
		
		[tmpBookData setValue:tmpBookCharData forKey:@"Characters"];
		[tmpBookData setValue:tmpBookQuoteData forKey:@"Quotes"];
		[bookData setValue:tmpBookData forKey:tmpBookTitle];

		[tmpBookTitle release];
		tmpBookTitle = nil;
		
		[tmpBookData release];
		tmpBookData = nil;
		
		[tmpBookCharData release];
		tmpBookCharData = nil;
		
		[tmpBookQuoteData release];
		tmpBookQuoteData = nil;
		
		/*
		if ([bookData count] == 1) {
			NSDictionary* TestBookData = [bookData valueForKey:@"1984"];
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
	
	if ([elementName isEqualToString:@"Title"]){
		
		tmpBookTitle = [currentStringValue copy];
		
		/*
		if ([currentStringValue rangeOfString:@"_"].location != NSNotFound) {
		    tmpBookTitle = [[currentStringValue replaceOccurrencesOfString:@"_" withString:@" "] copy];
		}
		else {
			tmpBookTitle = [currentStringValue copy];
		}
		*/
	}
	
	if ([elementName isEqualToString:@"Character"]) {
		insideChar = NO;
		
		if (tmpCharName != nil) {
			// [tmpCharName release];
			tmpCharName = nil;
		}
	}
	
	if ([elementName isEqualToString:@"Name"]) {
	
		if (insideChar) {
		    tmpCharName = [currentStringValue copy];
		}
	}
	
	if ([elementName isEqualToString:@"Summary"]) {

		if (insideChar) {
			if ([currentStringValue length] > 0) {
				// [tmpBookCharData setValue:@"A monkey's uncle" forKey:@"Aaron Kendall"];
				[tmpBookCharData setValue:[currentStringValue copy] forKey:tmpCharName];
			}
		}
	}
	
	if ([elementName isEqualToString:@"Quote"]) {
		insideQuote = NO;
		
		if ([currentStringValue length] > 10) {
		    // [tmpBookQuoteData setValue:currentStringValue forKey:[currentStringValue substringToIndex:10]];
			[tmpBookQuoteData setValue:@"X" forKey:currentStringValue];
			
		}
	}
	
	// [currentStringValue release];
	currentStringValue = nil;
	
	/*
	if (( [elementName isEqualToString:@"addresses"]) ||
        ( [elementName isEqualToString:@"address"] )) return;
	
	if ([elementName isEqualToString:@"lastName"]) {
		NSLog(@"lastname entering...%@",currentStringValue);
		[currentPerson setLastName:currentStringValue];
	}
	
	if ([elementName isEqualToString:@"firstName"]) {
		NSLog(@"first name entering...");
		[currentPerson setFirstName:currentStringValue];
	}
	if ([elementName isEqualToString:@"email"]) {
		NSLog(@"email entering...");
		[currentPerson setEmail:currentStringValue];
	}
	
	if ( [elementName isEqualToString:@"person"] ) {
        [addresses addObject:currentPerson];
        [currentPerson release];
        return;
    }
	*/	
}

-(IBAction)do:(id)sender
{
	int i = 0;
	// NSLog(@"first name:%@\nlast name:%@\nemail:%@",[[addresses objectAtIndex:i]firstName], [[addresses objectAtIndex:i]lastName], [[addresses objectAtIndex:i]email]);
}

- (void)dealloc {
	[bookData release];
	[super dealloc];
}

@end
