//
//  TemaTableViewController.m
//  Oficios
//
//  Created by Pablo Camiletti on 27/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


// VCs
#import "ChapterTableViewController.h"
//Model
#import "Chapter.h"
#import "Task.h"


@interface ChapterTableViewController ()
@end


@implementation ChapterTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.user.chapters.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.user.chapters[section] tasks] count];
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.user.chapters[section] chapterName];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TareaCell" forIndexPath:indexPath];
    
    Chapter *chapter = self.user.chapters[indexPath.section];
    cell.textLabel.text = [chapter.tasks[indexPath.row] taskName];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityNavigationController"];
    ActivityViewController *activityViewController = (ActivityViewController*)[navigationController topViewController];
    
    Chapter *chapter = self.user.chapters[indexPath.section];
    activityViewController.task = chapter.tasks[indexPath.row];
    activityViewController.delegate = self;
    activityViewController.resultsFileName = [NSString stringWithFormat:@"%@.results", self.user.userID];
    
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - Activity VC

- (void)activityHasFinishedSuccessfully:(BOOL)success
{
    if (success) {
        // Load next activity if there is
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
