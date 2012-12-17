//
//  SFObjectPattern.h
//  SFIoc
//
//  Created by Plato on 11/16/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SFObjectModeCreate,            // a new view controller is created each time
    SFObjectModeShare,             // a new view controller is created, cached and re-used
} SFObjectMode;

@interface SFObjectPattern : NSObject <NSCopying>

+(id)patternWithURL:(NSString *) url
     propertyValues:(NSDictionary *) values
   propertyRefBeans:(NSDictionary *) beans
         objectMode:(SFObjectMode) mode;

@property(nonatomic,retain) NSDictionary * values;
@property(nonatomic,retain) NSDictionary * beans;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,assign) NSInteger objectMode;

@end
