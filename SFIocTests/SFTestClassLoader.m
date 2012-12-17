//
//  SFTestClassLoader.m
//  SFIoc
//
//  Created by Plato on 12/17/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFTestClassLoader.h"
#import "SFTester.h"
#import "SFBeanTester.h"

@implementation SFTestClassLoader

-(void)loadWithURLMap:(TTURLMap *)map
{
    [super loadWithURLMap:map];
    
    [map from:@"tt://tester" toViewController:[SFTester class]];
    
    [map from:@"tt://refBean" toViewController:[SFBeanTester class]];
}

@end
