//
//  UsersTableViewController.h
//  Oficios
//
//  Created by Pablo Camiletti on 27/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewController.h"
#import "ChapterTableViewController.h"


@interface UsersTableViewController : UITableViewController <UISplitViewControllerDelegate, NSXMLParserDelegate, SettingsTableViewControllerDelegate, ChapterTableViewControllerDelegate>

@end
