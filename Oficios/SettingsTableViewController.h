//
//  SettingsTableViewController.h
//  Oficios
//
//  Created by Pablo Camiletti on 08/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewCell.h"

@protocol SettingsTableViewControllerDelegate;

@interface SettingsTableViewController : UITableViewController <SettingsTableViewCellDelegate>

@property (weak, nonatomic) id<SettingsTableViewControllerDelegate> delegate;

- (IBAction)doneButtonPressed:(id)sender;

@end


@protocol SettingsTableViewControllerDelegate <NSObject>
@required
- (void) settingsDidFinishEditting;
@end
