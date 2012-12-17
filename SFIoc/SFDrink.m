//
//  SFDrink.m
//  SFIoc
//
//  Created by Plato on 12/4/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFDrink.h"

@implementation SFDrink

- (void)dealloc
{
    TT_RELEASE_SAFELY(_name);
    TT_RELEASE_SAFELY(_price);
    [super dealloc];
}

-(id)initWithName:(NSString *) name
{
    if (self = [self init]) {
        self.name = name;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n name:%@ \n price: %f \n",self.name,[self.price floatValue]];
}
@end
