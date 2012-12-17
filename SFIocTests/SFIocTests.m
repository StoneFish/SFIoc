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
    //config with code
    [self configWithCode];
    
    //use xml file to config
    [self configWithXML];
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
