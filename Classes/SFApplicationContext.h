//
//  SFApplicationContext.h
//  SFIoc
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFBaseApplicationContext.h"

//附加到guider里面
@interface SFApplicationContext : SFBaseApplicationContext
{
    id <SFContextConfigurator> _xmlConfigurator;
}

//use specified xml file config context，if success return YES，else return NO。
-(BOOL)configApplicationContextForXmlPath:(NSString *) xmlPath;

@end
