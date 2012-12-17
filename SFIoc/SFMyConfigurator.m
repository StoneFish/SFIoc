//
//  SFMyConfigurator.m
//  SFIoc
//
//  Created by Plato on 12/16/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFMyConfigurator.h"
#import "SFMyClassLoader.h"

@implementation SFMyConfigurator

-(BOOL)startConfig
{
    SFObjectPattern * coffeePattern =
    [SFObjectPattern patternWithURL:[kCoffeeURL stringByAppendingString:@"/Blendy"]
                     propertyValues:@{@"price" : @30,
     @"sugar" : @"sugar sugar"}
                   propertyRefBeans:@{@"milk":@"orangeMilk"}
                         objectMode:SFObjectModeCreate];

    [self.delegate setPattern:coffeePattern forIdentifier:@"coffee"];
    
    SFObjectPattern * orangeMilkPattern =
    [SFObjectPattern patternWithURL:[kMilkURL stringByAppendingString:@"/Skim"]
                     propertyValues:@{@"price" : @10}
                   propertyRefBeans:nil
                         objectMode:SFObjectModeCreate];

    [self.delegate setPattern:orangeMilkPattern forIdentifier:@"orangeMilk"];

    return YES;
}
@end
