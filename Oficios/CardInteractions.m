//
//  CardInteractions.m
//  Oficios
//
//  Created by Pablo Camiletti on 07/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "CardInteractions.h"


@implementation CardInteractions


- (id) initWithCardID:(NSInteger)cardID
{
    if (self = [super init])
        self.cardID = cardID;
    
    return self;
}


@end
