//
//  TemaTableViewController.m
//  Oficios
//
//  Created by Pablo Camiletti on 27/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "TareaTableViewController.h"
#import "ActivityViewController.h"


@interface TareaTableViewController ()
@end


@implementation TareaTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.temas.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tareas[section] count];
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.temas[section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TareaCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.tareas[indexPath.section][indexPath.row];
    
    return cell;
}


/*
- (NSArray*) temas
{
    if (_temas == nil) {
        _temas = @[@"tema 1", @"tema 2", @"tema 3", @"tema 4"];
    }
    
    return _temas;
}


- (NSArray*) tareas
{
    if (_tareas == nil) {
        _tareas = @[@[@"tareas 1"],
                    @[@"tareas 1", @"tareas 2"],
                    @[@"tareas 1", @"tareas 2", @"tareas 3"],
                    @[@"tareas 1", @"tareas 2", @"tareas 3", @"tareas 4"]];
    }
    
    return _tareas;
}
*/


@end
