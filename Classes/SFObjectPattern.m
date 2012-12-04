//
//  SFObjectPattern.m
//  SFIoc
//
//  Created by Plato on 11/16/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFObjectPattern.h"

@implementation SFObjectPattern
@synthesize url = _url;
@synthesize values = _values;
@synthesize beans = _beans;
@synthesize objectMode = _objectMode;


- (void)dealloc
{
    TT_RELEASE_SAFELY(_url);
    TT_RELEASE_SAFELY(_values);
    TT_RELEASE_SAFELY(_beans);
    [super dealloc];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

+(id)patternWithURL:(NSString *)url
     propertyValues:(NSDictionary *)values
   propertyRefBeans:(NSDictionary *)beans
         objectMode:(NSInteger)mode
{
    return [[[self alloc]initWithURL:url
                      propertyValues:values
                    propertyRefBeans:beans
                          objectMode:mode] autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithURL:(NSString *) url
  propertyValues:(NSDictionary *)values
propertyRefBeans:(NSDictionary *)beans
      objectMode:(NSInteger)mode
{
    if (self = [self init]) {
        _url = [url copy];
        _values = [values retain];
        _beans = [beans retain];
        _objectMode = mode;
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

@end
