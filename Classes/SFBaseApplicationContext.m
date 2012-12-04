//
//  SFBaseApplicationContext.m
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFBaseApplicationContext.h"

@implementation SFBaseApplicationContext

- (void)dealloc
{
    TT_RELEASE_SAFELY(_classLoader);
    TT_RELEASE_SAFELY(_configurator);
    TT_RELEASE_SAFELY(_objectURLMap);
    TT_RELEASE_SAFELY(_objectMappings);
    TT_RELEASE_SAFELY(_objectPatterns);
    [super dealloc];
}

+(id)shareContext
{
    return [self shareObject];
}

- (id)init
{
    self = [super init];
    if (self) {
        //create class
        [self loadContext];
    }
    return self;
}

-(void)loadContext
{
    //load class
    [self.classLoader loadWithURLMap: self.objectURLMap];
    
    //config patterns
    [self.configurator configWith:self];
}

-(void) setPattern:(SFObjectPattern *) pattern forIdentifier:(NSString *)identifier
{
    if (nil == _objectPatterns) {
        _objectPatterns = [[NSMutableDictionary alloc]init];
    }
    [_objectPatterns setObject:pattern forKey:identifier];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(TTURLMap *)objectURLMap
{
    if (nil == _objectURLMap) {
        _objectURLMap = [[TTURLMap alloc]init];
    }
    return _objectURLMap;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setClassLoader:(id<SFClassLoader>)classLoader
{
    if (_classLoader) {
        [_classLoader release];
    }
    _classLoader = [classLoader retain];
    TT_RELEASE_SAFELY(_objectURLMap);
    
    [_classLoader loadWithURLMap:self.objectURLMap];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id<SFClassLoader>)classLoader
{
    if (!_classLoader) {
        [self createClassLoader];

        if (!_classLoader) {
            [self createInterstitialClassLoader];
        }
    }
    return _classLoader;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id<SFContextConfigurator>)configurator
{
    if (!_configurator) {
        [self createConfigurator];
        
        if (!_classLoader) {
            [self createInterstitialConfigurator];
        }
    }
    return _configurator;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)createClassLoader
{}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)createConfigurator
{}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma objectForIdentifier
-(id)objectForIdentifier:(NSString *)identifier
{
    return [self objectForIdentifier:identifier query:nil];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)objectForIdentifier:(NSString *)identifier query:(NSDictionary *)query
{
    id object = nil;
    if (_objectMappings) {
        object = [_objectMappings objectForKey:identifier];
        if (object) {
            return object;
        }
    }
    
    //如果是网页，返回一个网页视图控制器，这样后面的property就可以启用了
    if ([identifier hasPrefix:@"http://"]) {
        return [_objectURLMap objectForURL:identifier];
    }
    
    SFObjectPattern * objectPattern =  [self objectPatternForIdentifier:identifier];
    if (objectPattern) {
        object = [_objectURLMap objectForURL:objectPattern.url query:query];
        
        //set value properties
        for (NSString * keyPath in [objectPattern.values allKeys]) {
            id value = [objectPattern.values valueForKey:keyPath];
            [object setValue:value forKeyPath:keyPath];
        }
        
        //set ref properies
        for (NSString * keyPath in [objectPattern.beans allKeys]) {
            NSString * identifier = [objectPattern.beans valueForKey:keyPath];
            [object setValue:[self objectForIdentifier:identifier] forKeyPath:keyPath];
        }
        
        if (objectPattern.objectMode == SFObjectModeShare && object) {
            [self setObject:object forIdentifier:identifier];
        }
    }
    return object;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

+(void)doGarbageCollection
{}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -private
-(void)createInterstitialClassLoader
{
    [self setClassLoader:[[[SFClassLoader alloc] init] autorelease]];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)createInterstitialConfigurator
{
    [self setConfigurator:[[[SFContextConfigurator alloc] init] autorelease]];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (SFObjectPattern*)objectPatternForIdentifier:(NSString *)identifier {
    return [_objectPatterns objectForKey:identifier];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setObject:(id)object forIdentifier:(NSString *)identifier
{
    if (nil == _objectMappings) {
        _objectMappings = [[NSMutableDictionary alloc]init];
    }
    [_objectMappings setObject:object forKey:identifier];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
@end
