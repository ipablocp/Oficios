//
//  ViewController.h
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CardView.h"
@import AudioToolbox;


@interface ActivityViewController : UIViewController <CardViewDelegate, NSXMLParserDelegate>

// Data
@property (nonatomic, readonly) NSInteger numberOfCards;
@property (nonatomic, readonly) NSInteger numberOfSilhouettes;
@property (nonatomic, readonly) CGFloat maxAcceptableDistance;
@property (nonatomic, readonly) CGFloat maxAcceptableRotation;
@property (nonatomic, readonly) CGFloat maxAcceptableScale;
@property (nonatomic, strong) NSMutableArray *silhouetteSequence;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (strong, nonatomic) IBOutletCollection(CardView) NSArray *cardViewsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *silhouettes;
@property (strong, nonatomic) CAEmitterLayer *fireworksEmitter;

// Sounds
@property (strong, nonatomic) NSURL *correctSoundPath;
@property (strong, nonatomic) NSURL *incorrectSoundPath;

- (IBAction) objectTouched:(UIControl*)sender;

@end
