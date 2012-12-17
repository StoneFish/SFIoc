//
//  SFXMLParser.h
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFContextConfigurator.h"

@interface SFXMLConfigurator : SFContextConfigurator<NSXMLParserDelegate>

@property(nonatomic,retain) NSData * xmlData;

@property(nonatomic,readonly) NSError * parseError;

-(id)initWithData:(NSData *) data;

@end
