//
//  SFDrink.h
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFDrink <NSObject>

@property(nonatomic,copy) NSString * name;

@property(nonatomic,retain) NSNumber * price;

@end

@interface SFDrink : NSObject <SFDrink>

-(id)initWithName:(NSString *) name;

@property(nonatomic,copy) NSString * name;

@property(nonatomic,retain) NSNumber * price;

@end
