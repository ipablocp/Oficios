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
@property (strong, nonatomic) NSIndexPath *currentTaskIndexPath;
@property (strong, nonatomic) ActivityViewController *currentActivityViewController;
@end


@implementation ChapterTableViewController


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.user.chapters.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.user.chapters[section] tasks] count] + 1;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.user.chapters[section] chapterName];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TareaCell" forIndexPath:indexPath];
    
    Chapter *chapter = self.user.chapters[indexPath.section];
    
    if (indexPath.row < chapter.tasks.count) {
        cell.textLabel.text = [chapter.tasks[indexPath.row] taskID];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        cell.textLabel.text = @"+";
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityNavigationController"];
    ActivityViewController *activityViewController = (ActivityViewController*)[navigationController topViewController];
    
    self.currentTaskIndexPath = indexPath;
    Chapter *chapter = self.user.chapters[indexPath.section];
    
    if (indexPath.row < chapter.tasks.count) {
        self.currentActivityViewController = activityViewController;
        activityViewController.task = chapter.tasks[indexPath.row];
        activityViewController.editorMode = NO;
    }
    else
        activityViewController.editorMode = YES;
    
    activityViewController.delegate = self;
    
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - Activity VC

- (void)activityHasFinishedSuccessfully:(BOOL)success
{
    if (success) {
        // Load next activity if there is
        Task *nextTask;
        
        // There is another task in the current chapter
        if (self.currentTaskIndexPath.row < [self.tableView numberOfRowsInSection:self.currentTaskIndexPath.section]-2) {
            self.currentTaskIndexPath = [NSIndexPath indexPathForItem:self.currentTaskIndexPath.row+1 inSection:self.currentTaskIndexPath.section];
            Chapter *chapter = self.user.chapters[self.currentTaskIndexPath.section];
            nextTask = chapter.tasks[self.currentTaskIndexPath.row];
            self.currentActivityViewController.task = nextTask;
            [self.currentActivityViewController reloadUIForCurrentTask];
        }
        // Load the activity of next chapter
        else if (self.currentTaskIndexPath.section < [self.tableView numberOfSections]-1){
            self.currentTaskIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.currentTaskIndexPath.section+1];
            nextTask = [[self.user.chapters[self.currentTaskIndexPath.section] tasks] objectAtIndex:self.currentTaskIndexPath.row];
            self.currentActivityViewController.task = nextTask;
            [self.currentActivityViewController reloadUIForCurrentTask];
        }
        else {
            self.currentActivityViewController = nil;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        self.currentActivityViewController = nil;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void) activityHasFinishedEditingTask:(Task*)task;
{
    if (task != nil) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Chapter *chapter = self.user.chapters[indexPath.section];
        [chapter.tasks addObject:task];
    }
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(taskAdded)])
        [self.delegate taskAdded];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
