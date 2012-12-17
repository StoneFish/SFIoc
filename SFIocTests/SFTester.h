//
//  SFTester.h
//  SFIoc
//
//  Created by Plato on 12/17/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFBeanTester.h"

@interface SFTester : SFBeanTester

@property(nonatomic,copy) NSString * stringValue;

@property(nonatomic,retain) NSNumber * numberValue;

@property(nonatomic,assign) BOOL boolValue;

@property(nonatomic,retain) NSArray * arrayValue;

@property(nonatomic,retain) NSDictionary * dictionaryValue;

@property(nonatomic,retain) id beanValue;

@end
