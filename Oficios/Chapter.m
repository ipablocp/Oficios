//
//  Chapter.m
//  Oficios
//
//  Created by Pablo Camiletti on 07/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "Chapter.h"


@implementation Chapter


- (NSMutableArray *) tasks
{
    if (_tasks == nil)
        _tasks = [NSMutableArray array];
    
    return _tasks;
}


@end
