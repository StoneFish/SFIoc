//
//  SFCoffee.m
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFCoffee.h"

@implementation SFCoffee

-(void)setName:(NSString *)name
{
    [super setName:[name stringByAppendingString:@" Coffee"]];
}

-(NSString *)description
{
    NSString * des = [super description];
    return [NSString stringWithFormat:@"%@ sugar: %@ \n milk: %@",des,self.sugar,self.milk];
}

@end
