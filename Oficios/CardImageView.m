//
//  CardImageView.m
//  Oficios
//
//  Created by Pablo * on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "CardImageView.h"

@implementation CardImageView


#pragma mark - Init methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void) setup
{
    self.layer.magnificationFilter = kCAFilterTrilinear;
    self.layer.minificationFilter = kCAFilterTrilinear;
    self.layer.shouldRasterize = YES;
}


#pragma mark - 

- (void) flashImageBorderWithColor:(UIColor*)color
{
    
}


#pragma mark - Gestures handlers

- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    
    // Reset translation
    [recognizer setTranslation:CGPointZero inView:self.superview];
}


- (IBAction)handleRotation:(UIRotationGestureRecognizer*)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    
    // Reset rotation
    recognizer.rotation = 0.0;
}


- (IBAction)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
    
    // Reset scale
    recognizer.scale = 1.0;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
