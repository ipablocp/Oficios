//
//  UsersTableViewController.m
//  Oficios
//
//  Created by Pablo Camiletti on 27/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "UsersTableViewController.h"
#import "TareaTableViewController.h"


@interface UsersTableViewController ()
@property (strong, nonatomic) NSArray *users;
@end


@implementation UsersTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.users[indexPath.row];
    
    return cell;
}



- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[tableView indexPathForSelectedRow] isEqual:indexPath]) {
        UINavigationController *tareaNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"TareaNavigationController"];
        TareaTableViewController *tareaViewController = (TareaTableViewController*)[tareaNavigationController topViewController];
        
        NSMutableArray *tareas = [NSMutableArray array];
        NSMutableArray *temas = [NSMutableArray array];
        for (int i = 0; i < indexPath.row + 1; i++) {
            [temas addObject:[NSString stringWithFormat:@"temas %i", i]];
            
            NSMutableArray *grupoTareas = [NSMutableArray array];
            for (int j = 0; j < indexPath.row + 1; j++)
                [grupoTareas addObject:[NSString stringWithFormat:@"tareas %i", j]];
            
            [tareas addObject:grupoTareas];
        }
        
        tareaViewController.tareas = tareas;
        tareaViewController.temas = temas;
        
        // Load user activities
        UIViewController *navigationViewController = self.splitViewController.viewControllers[0];
        self.splitViewController.viewControllers = @[navigationViewController, tareaNavigationController];
        return indexPath;
    }
    else
        return nil;
}



#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *tareaNavigationController = [segue destinationViewController];
    TareaTableViewController *activityViewController = (TareaTableViewController*)[tareaNavigationController topViewController];
    
    NSMutableArray *tareas = [NSMutableArray array];
    NSMutableArray *temas = [NSMutableArray array];
    for (int i = 0; i < indexPath.row + 1; i++) {
        [tareas addObject:[NSString stringWithFormat:@"Tarea %i", i]];
        [temas addObject:[NSString stringWithFormat:@"Temas %i", i]];
    }
    
    activityViewController.tareas = tareas;
    activityViewController.temas = temas;
}
*/


- (NSArray*) users
{
    if (_users == nil) {
        _users = @[@"Profesor 1", @"Profesor 2", @"Profesor 3", @"Profesor 4"];
    }
    
    return _users;
}

@end
