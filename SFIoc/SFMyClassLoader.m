//
//  SFMyClassLoader.m
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFMyClassLoader.h"
#import "SFCoffee.h"
#import "SFMilk.h"

@implementation SFMyClassLoader

-(void)loadWithURLMap:(TTURLMap *)map
{
    [map from:kCoffeeURL toViewController:[SFCoffee class]];
    [map from:@"tt://coffee/(initWithName:)" toViewController:[SFCoffee class]];
    
    [map from:@"tt://milk" toViewController:[SFCoffee class]];
    [map from:@"tt://milk/(initWithName:)" toViewController:[SFMilk class]];
    
}

@end
