//
//  CardImageView.h
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
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
@property (strong, nonatomic) UIImageView *starImageView;

// Gesture recognizers
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;

// Delegate
@property (weak, nonatomic) id<CardViewDelegate> delegate;


// Actions
- (void) flashCardWithColor:(UIColor*)color;
- (void) moveToOriginalPosition;

// Gestures handlers
- (void)handlePan:(UIPanGestureRecognizer*)recognizer;
- (void)handleRotation:(UIRotationGestureRecognizer*)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer;

@end



@protocol CardViewDelegate <NSObject>
@optional
- (void) cardEndedInteracting:(CardView*)card;
@end