//
//  SFMilk.m
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFMilk.h"

@implementation SFMilk

-(void)setName:(NSString *)name
{
    [super setName:[name stringByAppendingString:@" Milk"]];
}

@end
