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
@property (strong, nonatomic) NSMutableArray *interactions;
@property (nonatomic) BOOL oneFingerRotationEnable;
@property (nonatomic, readonly) BOOL animatingColorOverlay;

// UI
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *starImageView;
@property (strong, nonatomic) NSString *imageName;

// Gesture recognizers
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
//@property (strong, nonatomic) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;


// Delegate
@property (weak, nonatomic) id<CardViewDelegate> delegate;


// Actions
- (void) flashCardWithColor:(UIColor*)color;
- (void) moveToOriginalPosition;
- (void) showStarAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void) hideStarAnimated:(BOOL)animated;

// Animations
- (void) animateFlickeringColorOverlay;
- (void) stopAnimatingFlickeringColorOverlay;

@end



@protocol CardViewDelegate <NSObject>
@optional
- (void) cardView:(CardView*)card willBegingRecognizingGesture:(UIGestureRecognizer*)gestureRecognizer;
- (void) cardEndedInteracting:(CardView*)card;
@end