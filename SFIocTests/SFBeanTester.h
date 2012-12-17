//
//  SFBeanTester.h
//  SFIoc
//
//  Created by Plato on 12/17/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBeanTester : NSObject

@property(nonatomic,readonly) NSNumber * randomIdentifier;

@property(nonatomic,retain) SFBeanTester * subBean;

@end
