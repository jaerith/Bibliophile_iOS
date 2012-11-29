//
//  FileParser.h
//  BiblioPhile
//
//  Created by mac on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileParser : NSObject {
    NSXMLParser*     bookDataParser;
	NSMutableString* currentStringName;
	NSMutableString* currentStringValue;
	NSMutableArray*  dictProperties;
	BOOL             insideProduct;
	BOOL             insideChar;
	BOOL             insideQuote;
	
	NSMutableString*     tmpBookTitle;
	NSMutableString*     tmpCharName;
	NSMutableDictionary* tmpBookData;
	NSMutableDictionary* tmpBookCharData;
	NSMutableDictionary* tmpBookQuoteData;

	NSMutableDictionary* bookData;
	NSMutableDictionary* musicData;
}

- (void) parseXMLFile:(NSString*) pathToFile;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString;

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

-(IBAction) do:(id)sender;

@property (nonatomic) NSMutableDictionary* bookData;
@property (nonatomic) NSMutableDictionary* musicData;

@end
