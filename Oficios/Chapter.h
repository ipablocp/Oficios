//
//  Chapter.h
//  Oficios
//
//  Created by Pablo Camiletti on 07/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject

@property (strong, nonatomic) NSString *chapterID;
@property (strong, nonatomic) NSString *chapterName;
@property (strong, nonatomic) NSMutableArray *tasks;

@end
