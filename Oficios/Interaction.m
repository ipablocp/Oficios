//
//  Interaction.m
//  Oficios
//
//  Created by Pablo Camiletti on 07/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "Interaction.h"

@implementation Interaction


- (id) initWithName:(NSString*)name startTime:(clock_t)start
{
    if (self = [super init]) {
        self.name = name;
        self.start = start;
        self.isCorrect = NO;
    }
    
    return self;
}


@end
