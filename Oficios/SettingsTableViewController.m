//
//  SettingsTableViewController.m
//  Oficios
//
//  Created by Pablo Camiletti on 08/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "SettingsTableViewController.h"


@interface SettingsTableViewController ()
@end


@implementation SettingsTableViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsTableViewCell *cell = (SettingsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"settings cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Completar siluetas en orden";
        [cell.switchControl setOn:[defaults boolForKey:cell.textLabel.text] animated:NO];
    }
    
    return cell;
}


- (void) switchDidChangeInCell:(SettingsTableViewCell*)cell
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:cell.switchControl.on forKey:cell.textLabel.text];
    [defaults synchronize];
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)doneButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(settingsDidFinishEditting)])
        [self.delegate settingsDidFinishEditting];
}


@end
