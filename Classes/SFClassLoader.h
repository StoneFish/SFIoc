//
//  SFClassLoader.h
//  SFIoc
//
//  Created by Rocky Lee on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SFClassLoader <NSObject>

-(void)loadWithURLMap:(TTURLMap *) map;

@end

@interface SFClassLoader : NSObject <SFClassLoader>

-(void)loadWithURLMap:(TTURLMap *)map;

//create view controllers from nib
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className;
- (UIViewController*)loadFromNib:(NSString*)className;

@end

