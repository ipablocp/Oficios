//
//  Interaction.h
//  Oficios
//
//  Created by Pablo Camiletti on 07/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Interaction : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSDate *start;
@property (nonatomic) NSDate *end;
@property (nonatomic) BOOL isCorrect;

- (id) initWithName:(NSString*)name startTime:(NSDate*)start;

@end
