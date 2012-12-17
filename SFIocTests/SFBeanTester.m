//
//  SFBeanTester.m
//  SFIoc
//
//  Created by Plato on 12/17/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "SFBeanTester.h"

@implementation SFBeanTester

- (void)dealloc
{
    TT_RELEASE_SAFELY(_randomIdentifier);
    TT_RELEASE_SAFELY(_subBean);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _randomIdentifier = [[NSNumber alloc]initWithLong:random()];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n %@ \n subBean: %@\n",self.randomIdentifier,self.subBean];
}
@end
