//
//  SFIocTests.m
//  SFIocTests
//
//  Created by Plato on 12/3/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFIocTests.h"
#import "SFApplicationContext.h"
#import "SFMyClassLoader.h"

@implementation SFIocTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    id <SFClassLoader> classLoader = [[[SFMyClassLoader alloc]init] autorelease];
    
    SFApplicationContext * context = [SFApplicationContext shareContext];
    //TODO:put it in subclass of context
    /* if you want to use SFClassLoader to create view Controller from nib
     * you should make sure your loader will be living 
     * context will retain the loader, you can use [context setClassLoader:id<SFClassLoader>] to retain your loader,and it will automatically call the function 
     -(void)loadWithURLMap:(TTURLMap *) map 
        in your loader
     */
    [context setClassLoader:classLoader];
    [context configApplicationContextForXmlPath:@""];
    
    SFObjectPattern * coffeePattern =
    [SFObjectPattern patternWithURL:[kCoffeeURL stringByAppendingString:@"/Blendy"]
                     propertyValues:@{@"price" : @30,
     @"sugar" : @"sugar sugar"}
                   propertyRefBeans:@{@"milk":@"orangeMilk"}
                         objectMode:SFObjectModeCreate];
    
    
    [context setPattern:coffeePattern forIdentifier:@"coffee"];
    
    SFObjectPattern * orangeMilkPattern =
    [SFObjectPattern patternWithURL:[kMilkURL stringByAppendingString:@"/Skim"]
                     propertyValues:@{@"price" : @10}
                   propertyRefBeans:nil
                         objectMode:SFObjectModeCreate];
    
    [context setPattern:orangeMilkPattern forIdentifier:@"orangeMilk"];
                                      
    id coffee = [context objectForIdentifier:@"coffee"];

    TTDPRINT(@"%@",coffee);
}

@end
