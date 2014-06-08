//
//  TemaTableViewController.h
//  Oficios
//
//  Created by Pablo Camiletti on 27/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityViewController.h"
#import "User.h"

@interface ChapterTableViewController : UITableViewController <ActivityViewControllerDelegate>

@property (strong, nonatomic) User *user;

@end
