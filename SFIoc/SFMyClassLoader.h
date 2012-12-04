//
//  SFMyClassLoader.h
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFClassLoader.h"

static NSString * kCoffeeURL = @"tt://coffee";
static NSString * kMilkURL = @"tt://milk";

@interface SFMyClassLoader : SFClassLoader

-(void)loadWithURLMap:(TTURLMap *)map;

@end
