//
//  CardInteractions.h
//  Oficios
//
//  Created by Pablo Camiletti on 07/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardInteractions : NSObject

@property (nonatomic) NSInteger cardID;
@property (strong, nonatomic) NSMutableArray *interacions;

- (id) initWithCardID:(NSInteger)cardID;

@end
