//
//  SFTester.m
//  SFIoc
//
//  Created by Plato on 12/17/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFTester.h"

@implementation SFTester

- (void)dealloc
{
    TT_RELEASE_SAFELY(_stringValue);
    TT_RELEASE_SAFELY(_numberValue);
    TT_RELEASE_SAFELY(_dictionaryValue);
    TT_RELEASE_SAFELY(_arrayValue);
    TT_RELEASE_SAFELY(_beanValue);
    [super dealloc];
}

-(NSString *)description
{
    return
    [NSString stringWithFormat:@"%@ string:%@ \n number: %f  \n bool:%i \n dictionary:%@ \n array: %@\n bean:%@ \n",[super description],self.stringValue,[self.numberValue doubleValue],self.boolValue,self.dictionaryValue,self.arrayValue,self.beanValue];
}
@end
