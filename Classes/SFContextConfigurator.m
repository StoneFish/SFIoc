//
//  SFContextConfigurator.m
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFContextConfigurator.h"

@implementation SFContextConfigurator

-(BOOL)configWithDelegate:(id<SFConfigurable>)delegate
{
    self.delegate = delegate;
    return [self startConfig];
}

-(BOOL)startConfig
{
    return YES;
}

@end
