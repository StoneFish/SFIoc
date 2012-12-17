//
//  HDApplicationContext.m
//  SFIoc
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFApplicationContext.h"
#import "SFXMLConfigurator.h"

@implementation SFApplicationContext

-(BOOL)configApplicationContextForXmlPath:(NSString *)xmlPath
{
    NSString * filePath = nil;
    if (TTIsBundleURL(xmlPath)) {
        filePath = TTPathForBundleResource([xmlPath substringFromIndex:9]);
    }
    if (TTIsDocumentsURL(xmlPath)) {
        filePath = TTPathForDocumentsResource([xmlPath substringFromIndex:12]);
    }
    NSData * xmlData = [NSData dataWithContentsOfFile:filePath];
    SFXMLConfigurator * parser = [[[SFXMLConfigurator alloc]initWithData:xmlData]autorelease];
    return [parser configWithDelegate:self];
}

@end
