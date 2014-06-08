//
//  User.m
//  Oficios
//
//  Created by Pablo Camiletti on 07/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "User.h"

@implementation User

- (NSMutableArray *) chapters
{
    if (_chapters == nil)
        _chapters = [NSMutableArray array];
    
    return _chapters;
}

@end
