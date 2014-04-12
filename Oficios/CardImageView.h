//
//  CardImageView.h
//  Oficios
//
//  Created by Pablo * on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardImageView : UIImageView <UIGestureRecognizerDelegate>

- (void) flashImageBorderWithColor:(UIColor*)color;

// Gestures handlers
- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer;
- (IBAction)handleRotation:(UIRotationGestureRecognizer*)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer*)recognizer;

@end
