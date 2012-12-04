//
//  SFClassLoader.m
//  SFIoc
//
//  Created by Rocky Lee on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SFClassLoader.h"

@implementation SFClassLoader

-(void)loadWithURLMap:(TTURLMap *)map
{
    [map from:@"tt://nib/(loadFromNib:)/(withClass:)"
           toViewController:self];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark load from nib
/**
 * Loads the given viewcontroller from the nib
 */
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className {
    UIViewController* newController = [[NSClassFromString(className) alloc]
                                       initWithNibName:nibName bundle:nil];
    
    return [newController autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Loads the given viewcontroller from the the nib with the same name as the
 * class
 */
- (UIViewController*)loadFromNib:(NSString*)className {
    return [self loadFromNib:className withClass:className];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

@end
