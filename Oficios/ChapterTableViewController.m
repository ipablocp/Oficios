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
    self.currentTaskIndexPath = indexPath;
    Chapter *chapter = self.user.chapters[indexPath.section];
    [self presentActivityWithTask:chapter.tasks[indexPath.row] animated:YES];
}


- (void) presentActivityWithTask:(Task*)task animated:(BOOL)animated
{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityNavigationController"];
    ActivityViewController *activityViewController = (ActivityViewController*)[navigationController topViewController];
    
    activityViewController.task = task;
    activityViewController.delegate = self;
    activityViewController.resultsFileName = [NSString stringWithFormat:@"%@.results", self.user.userID];
    
    [self.navigationController presentViewController:navigationController animated:animated completion:nil];
}


#pragma mark - Activity VC

- (void)activityHasFinishedSuccessfully:(BOOL)success
{
    if (success) {
        // Load next activity if there is
        Task *nextTask;
        
        // There is another task in the current chapter
        if (self.currentTaskIndexPath.row < [self.tableView numberOfRowsInSection:self.currentTaskIndexPath.section]-1) {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            self.currentTaskIndexPath = [NSIndexPath indexPathForItem:self.currentTaskIndexPath.row+1 inSection:self.currentTaskIndexPath.section];
            nextTask = [[self.user.chapters[self.currentTaskIndexPath.section] tasks] objectAtIndex:self.currentTaskIndexPath.row];
            [self presentActivityWithTask:nextTask animated:NO];
        }
        // Load the activity of next chapter
        else if (self.currentTaskIndexPath.section < [self.tableView numberOfSections]-1){
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            self.currentTaskIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.currentTaskIndexPath.section+1];
            nextTask = [[self.user.chapters[self.currentTaskIndexPath.section] tasks] objectAtIndex:self.currentTaskIndexPath.row];
            [self presentActivityWithTask:nextTask animated:NO];
        }
        else
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
