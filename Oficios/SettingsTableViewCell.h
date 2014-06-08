//
//  SettingsTableViewCell.h
//  Oficios
//
//  Created by Pablo Camiletti on 08/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol SettingsTableViewCellDelegate;


@interface SettingsTableViewCell : UITableViewCell


@property (strong, nonatomic) UISwitch *switchControl;

@property (weak, nonatomic) id<SettingsTableViewCellDelegate> delegate;

- (void) switchControlPressed:(UISwitch*)sender;


@end


@protocol SettingsTableViewCellDelegate <NSObject>
@optional
- (void) switchDidChangeInCell:(SettingsTableViewCell*)cell;

@end