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
#import "SFMyConfigurator.h"

#import "SFTestClassLoader.h"
#import "SFTester.h"
#import "SFBeanTester.h"

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
    [self xmlTester];
    
    //config with code sample
//    [self configWithCode];
    
    //use xml file to config sample
//    [self configWithXML];
}

-(void)xmlTester
{
    SFApplicationContext * context = [SFApplicationContext shareContext];
    SFClassLoader * classLoader = [[[SFTestClassLoader alloc]init] autorelease];
    [context setClassLoader:classLoader];

    TTDASSERT([context configApplicationContextForXmlPath:@"bundle://UnitTest.xml"]);
    SFTester *tester = [context objectForIdentifier:@"tester"];
    SFTester *copiedTester = [context objectForIdentifier:@"copiedTester"];
    SFTester *sharedTester = [context objectForIdentifier:@"sharedTester"];
    SFBeanTester *refShareBean = [context objectForIdentifier:@"refShareBean"];
    SFBeanTester *refCreationBean = [context objectForIdentifier:@"refCreationBean"];
    SFBeanTester * refShareSubBean = [context objectForIdentifier:@"refShareSubBean"];
    
    NSArray * arrary = @[@"1" ,@"y" ,@1];
    NSDictionary * dictionary = @{@"a" : @"A101" ,@"b" :@"B-D999",@"c":@"C103"};
    
    TTDASSERT([tester.stringValue isEqualToString:@"I am tester"]);
    TTDASSERT([tester.numberValue isEqualToNumber:@1]);
    TTDASSERT(tester.boolValue == YES);
    TTDASSERT([[tester.arrayValue objectAtIndex:0] isEqualToString:[arrary objectAtIndex:0]]);
    TTDASSERT(tester.arrayValue.count == arrary.count);
    TTDASSERT([[tester.dictionaryValue valueForKey:@"b"]isEqualToString:[dictionary valueForKey:@"b"]]);
    TTDASSERT(tester.beanValue == refShareBean);
    TTDASSERT(nil != [tester.beanValue subBean] && [[tester.beanValue subBean]isEqual:refShareSubBean]);
        
    TTDASSERT([copiedTester.stringValue isEqualToString:@"I am copied tester"]);
    TTDASSERT([copiedTester.numberValue isEqualToNumber:@(-1)]);
    TTDASSERT(copiedTester.boolValue ==NO);
    TTDASSERT(copiedTester.beanValue != refCreationBean);
    
    TTDASSERT([sharedTester.stringValue isEqualToString:tester.stringValue]);
    TTDASSERT([sharedTester.numberValue isEqualToNumber:tester.numberValue]);
    TTDASSERT(sharedTester.boolValue == tester.boolValue);
    TTDASSERT([sharedTester.arrayValue isEqualToArray:tester.arrayValue]);
    TTDASSERT([sharedTester.dictionaryValue isEqualToDictionary:tester.dictionaryValue]);
    TTDASSERT([sharedTester.beanValue isEqual:tester.beanValue]);
}

-(void)configWithCode
{
    SFApplicationContext * context = [SFApplicationContext shareContext];
    //PS:put it in subclass of context
    /* if you want to use SFClassLoader to create view Controller from nib
     * you should make sure your loader will be living
     * context will retain the loader, you can use [context setClassLoader:id<SFClassLoader>] to retain your loader,and it will automatically call the function
     -(void)loadWithURLMap:(TTURLMap *) map
     in your loader
     */
    id <SFClassLoader> classLoader = [[[SFMyClassLoader alloc]init] autorelease];
    [context setClassLoader:classLoader];
    
    id <SFContextConfigurator> configurator = [[[SFMyConfigurator alloc]init] autorelease];
    
    TTDPRINT(@"%d",[configurator configWithDelegate:context]);
    
    id coffee = [context objectForIdentifier:@"coffee"];
    
    TTDPRINT(@"%@",coffee);

}

-(void)configWithXML
{
    SFApplicationContext * context = [SFApplicationContext shareContext];
    TTDASSERT([context configApplicationContextForXmlPath:@"bundle://beans.xml"]);
    
    id <SFClassLoader> classLoader = [[[SFMyClassLoader alloc]init] autorelease];
    [context setClassLoader:classLoader];
    
    id coffee = [context objectForIdentifier:@"coffee"];
    
    TTDPRINT(@"%@",coffee);
}

@end
