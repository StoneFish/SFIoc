//
//  SFBaseApplicationContext.h
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFSingletonObject.h"
#import "SFObjectPattern.h"
#import "SFClassLoader.h"
#import "SFContextConfigurator.h"

@interface SFBaseApplicationContext : SFSingletonObject <SFConfigurable>
{
    //对象配置模式，保存了对象id和相关属性，创建url等信息
    NSMutableDictionary * _objectPatterns;
    //共享属性的对象会被容器保持
    NSMutableDictionary * _objectMappings;
    TTURLMap * _objectURLMap;
    
    id <SFClassLoader> _classLoader;
}

//get context object
+(id)shareContext;
///////////////////////////////////////////////////////////////////////////////////////////////////

//binding constructor functions for Classes with url,see SFClassLoader to get more details.
@property (nonatomic,retain) id<SFClassLoader> classLoader;
///////////////////////////////////////////////////////////////////////////////////////////////////

@property(nonatomic,retain) id<SFContextConfigurator> configurator;
///////////////////////////////////////////////////////////////////////////////////////////////////

//TT的对象工厂，通过注册url和class，可以通过url的方式创建对象
@property(nonatomic,readonly) TTURLMap * objectURLMap;
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadContext;
///////////////////////////////////////////////////////////////////////////////////////////////////

//通过id获取指定对象
-(id)objectForIdentifier:(NSString *)identifier;

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)objectForIdentifier:(NSString *)identifier query:(NSDictionary *)query;

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setPattern:(SFObjectPattern *) pattern forIdentifier:(NSString *)identifier;

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)createClassLoader;

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)createConfigurator;

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (void)doGarbageCollection;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
