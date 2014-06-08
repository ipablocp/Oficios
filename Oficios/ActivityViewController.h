//
//  ViewController.h
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CardView.h"
#import "SilhouetteButton.h"
#import "Task.h"
@import AudioToolbox;

@protocol ActivityViewControllerDelegate;


@interface ActivityViewController : UIViewController <CardViewDelegate, NSXMLParserDelegate, UIAlertViewDelegate>

// Data
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) NSString *resultsFileName;
@property (nonatomic, readonly) CGFloat maxAcceptableDistance;
@property (nonatomic, readonly) CGFloat maxAcceptableRotation;
@property (nonatomic, readonly) CGFloat maxAcceptableScaleVariation;
@property (nonatomic) int remainingSilhouettes;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (strong, nonatomic) NSMutableArray *cardViewsArray;
@property (strong, nonatomic) NSMutableArray *silhouettes;

// Sounds
@property (strong, nonatomic) NSURL *correctSoundPath;
@property (strong, nonatomic) NSURL *incorrectSoundPath;
@property (nonatomic, readonly) SystemSoundID correctSoundID;
@property (nonatomic, readonly) SystemSoundID incorrectSoundID;

@property (weak, nonatomic) id<ActivityViewControllerDelegate> delegate;

- (IBAction) objectTouched:(UIControl*)sender;

- (IBAction) closeActivity;

- (void) reloadUIForCurrentTask;

@end


@protocol ActivityViewControllerDelegate <NSObject>
@required
- (void) activityHasFinishedSuccessfully:(BOOL)success;
@end