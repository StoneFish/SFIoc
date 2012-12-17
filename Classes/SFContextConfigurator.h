//
//  SFContextConfigurator.h
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFObjectPattern.h"

@protocol SFConfigurable <NSObject>

-(void)setPattern:(SFObjectPattern *) pattern forIdentifier:(NSString *)identifier;

-(SFObjectPattern*)objectPatternForIdentifier:(NSString *)identifier;

@end

@protocol SFContextConfigurator <NSObject>

-(BOOL)configWithDelegate:(id <SFConfigurable>) delegate;

@end

@interface SFContextConfigurator : NSObject <SFContextConfigurator>

-(BOOL)configWithDelegate:(id<SFConfigurable>)delegate;

-(BOOL)startConfig;

@property(nonatomic,assign) id<SFConfigurable> delegate;

@end
