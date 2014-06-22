//
//  UsersTableViewController.m
//  Oficios
//
//  Created by Pablo Camiletti on 27/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


// VCs
#import "UsersTableViewController.h"
// Model
#import "User.h"
#import "Chapter.h"
#import "Task.h"


@interface UsersTableViewController ()
@property (strong, nonatomic) NSMutableArray *users;
@end


@implementation UsersTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Read XML users
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *nameOfFile = @"sesion.config";
    NSString *fileString = [@"file://" stringByAppendingString:[documentsDirectory stringByAppendingPathComponent:nameOfFile]];
    NSURL *fileURL = [NSURL URLWithString:[fileString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    [parser setDelegate:self];
    BOOL parsedSuccessfully = [parser parse];
    
    if (!parsedSuccessfully)
        NSLog(@"Error parsing the file %@", nameOfFile);
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
    
    cell.textLabel.text = [self.users[indexPath.row] name];
    
    return cell;
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[tableView indexPathForSelectedRow] isEqual:indexPath]) {
        UINavigationController *tareaNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"TareaNavigationController"];
        ChapterTableViewController *tareaViewController = (ChapterTableViewController*)[tareaNavigationController topViewController];

        tareaViewController.user = self.users[indexPath.row];
        tareaViewController.delegate = self;
        
        // Load user activities
        UIViewController *navigationViewController = self.splitViewController.viewControllers[0];
        self.splitViewController.viewControllers = @[navigationViewController, tareaNavigationController];
        return indexPath;
    }
    else
        return nil;
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationController = segue.destinationViewController;
        if ([navigationController.topViewController isKindOfClass:[SettingsTableViewController class]])
            ((SettingsTableViewController*)navigationController.topViewController).delegate = self;
    }
}


#pragma mark - XML parsing

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Parse users
    if ([elementName isEqual:@"usuario"]){
        User *user = [[User alloc] init];
        user.userID = [attributeDict objectForKey:@"id"];
        user.name = [attributeDict objectForKey:@"name"];
        [self.users addObject:user];
    }
    
    // Parse chapters
    else if ([elementName isEqual:@"tema"]) {
        User *user = [self.users lastObject];
        Chapter *chapter = [[Chapter alloc] init];
        chapter.chapterID = [attributeDict objectForKey:@"id"];
        chapter.chapterName = [attributeDict objectForKey:@"name"];
        [user.chapters addObject:chapter];
    }
    
    // Parse tasks
    else if ([elementName isEqual:@"tarea"]){
        User *user = [self.users lastObject];
        Chapter *chapter = [user.chapters lastObject];
        Task *task = [[Task alloc] init];
        task.taskID = [attributeDict objectForKey:@"id"];
        [chapter.tasks addObject:task];
    }
}


// Error handling
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}


- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}


- (void) saveSession
{
    NSMutableString *sessionString = [[NSMutableString alloc] init];
    
    for (User *user in self.users) {
        [sessionString appendFormat:@"<usuario id=\"%@\" name=\"%@\"> \n\n", user.userID, user.name];
        
        for (Chapter *chapter in user.chapters) {
            [sessionString appendFormat:@"\t <tema id=\"%@\" name=\"%@\"> \n", chapter.chapterID, chapter.chapterName];
            
            for (Task *task in chapter.tasks)
                [sessionString appendFormat:@"\t\t <tarea id=\"%@\" /> \n", task.taskID];
            
            [sessionString appendFormat:@"\t </tema> \n\n"];
        }
        
        [sessionString appendFormat:@"</usuario> \n\n"];
    }
    
    // Get file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/sesion.config"];
    NSLog(@"filePath = %@", filePath);
    
    // Write results to file
    NSError *error;
    BOOL succeed = [sessionString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (!succeed)
        NSLog(@"Error writing the results to file: %@", error);
}


#pragma mark - Settings delegate

- (void) settingsDidFinishEditting
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ChapterTableViewControllerDelegate

- (void) taskAdded
{
    [self saveSession];
}


#pragma mark - Property implementatio

- (NSMutableArray*) users
{
    if (_users == nil)
        _users = [NSMutableArray array];
    
    return _users;
}


@end
