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
#import "ImagePickerController.h"
@import AudioToolbox;

@protocol ActivityViewControllerDelegate;


@interface ActivityViewController : UIViewController <CardViewDelegate, NSXMLParserDelegate, UIAlertViewDelegate, ImagePickerControllerDelegate>

// Data
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) NSString *resultsFileName;
@property (nonatomic, readonly) CGFloat maxAcceptableDistance;
@property (nonatomic, readonly) CGFloat maxAcceptableRotation;
@property (nonatomic, readonly) CGFloat maxAcceptableScaleVariation;
@property (nonatomic) NSInteger remainingSilhouettes;
@property (nonatomic) BOOL editorMode;
@property (strong, nonatomic) NSString *activityImageName;

// UI Play Mode
@property (weak, nonatomic) IBOutlet UIButton *activityImageButton;
@property (strong, nonatomic) NSMutableArray *cardViewsArray;
@property (strong, nonatomic) NSMutableArray *silhouettes;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

// UI Edit Mode
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property (weak, nonatomic) IBOutlet UIButton *addSilhouetteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteCardButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteSilhouetteButton;
@property (weak, nonatomic) IBOutlet UIButton *maxDistanceButton;
@property (weak, nonatomic) IBOutlet UIButton *maxRotationButton;
@property (weak, nonatomic) IBOutlet UIButton *maxScaleButton;

// Sounds
@property (strong, nonatomic) NSURL *correctSoundPath;
@property (strong, nonatomic) NSURL *incorrectSoundPath;
@property (nonatomic, readonly) SystemSoundID correctSoundID;
@property (nonatomic, readonly) SystemSoundID incorrectSoundID;

@property (weak, nonatomic) id<ActivityViewControllerDelegate> delegate;

- (void) objectTouched:(UIControl*)sender;

- (IBAction) closeActivity;
// Edit mode
- (IBAction) saveButtonPressed:(id)sender;
- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) showImagePicker:(id)sender;
- (IBAction) addNewCard:(UIButton*)sender;
- (IBAction) addNewSilhouette:(UIButton*)sender;
- (IBAction) deleteSilhouetteButtonPressed:(UIButton*)sender;
- (IBAction) deleteCardButtonPressed:(UIButton*)sender;
- (IBAction) maxDistanceButtonPressed;
- (IBAction) maxRotationButtonPressed;
- (IBAction) maxScaleButtonPressed;

- (void) reloadUIForCurrentTask;

@end


@protocol ActivityViewControllerDelegate <NSObject>
@required
- (void) activityHasFinishedSuccessfully:(BOOL)success;
- (void) activityHasFinishedEditingTask:(Task*)task;
@end