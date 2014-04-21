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
@import AudioToolbox;


@interface ActivityViewController : UIViewController <CardViewDelegate, NSXMLParserDelegate>

// Data
@property (nonatomic, readonly) CGFloat maxAcceptableDistance;
@property (nonatomic, readonly) CGFloat maxAcceptableRotation;
@property (nonatomic, readonly) CGFloat maxAcceptableScale;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (strong, nonatomic) NSMutableArray *cardViewsArray;
@property (strong, nonatomic) NSMutableArray *silhouettes;
@property (strong, nonatomic) CAEmitterLayer *fireworksEmitter;

// Sounds
@property (strong, nonatomic) NSURL *correctSoundPath;
@property (strong, nonatomic) NSURL *incorrectSoundPath;
@property (nonatomic, readonly) SystemSoundID correctSoundID;
@property (nonatomic, readonly) SystemSoundID incorrectSoundID;

- (IBAction) objectTouched:(UIControl*)sender;

@end
