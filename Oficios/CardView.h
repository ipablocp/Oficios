//
//  CardImageView.h
//  Oficios
//
//  Created by Pablo * on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CardViewDelegate;


@interface CardView : UIControl <UIGestureRecognizerDelegate>

// Data
@property (nonatomic) NSInteger cardID;
@property (nonatomic) CGPoint originalCenter;

// UI
@property (strong, nonatomic) UIImageView *imageView;

// Gesture recognizers
@property (nonatomic, weak) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) IBOutlet UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (nonatomic, weak) IBOutlet UIPinchGestureRecognizer *pinchGestureRecognizer;

// Delegate
@property (weak, nonatomic) id<CardViewDelegate> delegate;


// Actions
- (void) flashCardWithColor:(UIColor*)color;
- (void) moveToOriginalPosition;

// Gestures handlers
- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer;
- (IBAction)handleRotation:(UIRotationGestureRecognizer*)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer*)recognizer;

@end



@protocol CardViewDelegate <NSObject>
@optional
- (void) cardEndedInteracting:(CardView*)card;
@end