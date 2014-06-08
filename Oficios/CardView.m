//
//  CardImageView.m
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "CardView.h"
#import "UIImage+Extensions.h"
#import "Interaction.h"


@interface CardView ()
@end


@implementation CardView


#pragma mark - Init methods

- (id) init
{
    if (self = [super init])
        [self setup];
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self setup];
    
    return self;
}


- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self setup];

    return self;
}


- (void) setup
{
    // Set image quality
    self.imageView.layer.magnificationFilter = kCAFilterTrilinear;
    self.imageView.layer.minificationFilter = kCAFilterTrilinear;
    self.imageView.layer.shouldRasterize = YES;
}


#pragma mark - Actions

- (void) flashCardWithColor:(UIColor*)color
{
    UIImage *originalImage = self.imageView.image;
    
    self.imageView.image = [originalImage imageWithOverlayColor:color];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.imageView.image = originalImage;
        
    });
}


- (void) moveToOriginalPosition
{
    self.center = self.originalCenter;
}


- (void) showStarAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    if (animated) {
        self.starImageView.transform = CGAffineTransformMakeScale(.0, .0);
        
        [UIView animateWithDuration:2.0 delay:.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.starImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:completion];
    }
    else {
        self.starImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        if (completion)
            completion(YES);
    }
    
    self.starImageView.hidden = NO; // In case is was hidden
    self.starImageView.alpha = 1.0; // In case it was set to transparent
}


- (void) hideStarAnimated:(BOOL)animated
{
    if (animated) {
        self.starImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [UIView animateWithDuration:.3 animations:^{
            self.starImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            if (finished) {
                [self.starImageView removeFromSuperview];
                self.starImageView = nil;
            }
        }];
    }
    else {
        [self.starImageView removeFromSuperview];
        self.starImageView = nil;
    }
}


#pragma mark - Gestures handlers

- (void) handlePan:(UIPanGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(cardView:willBegingRecognizingGesture:)])
        [self.delegate cardView:self willBegingRecognizingGesture:recognizer];
    
    // Move itself
    CGPoint translation = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    
    // Reset translation
    [recognizer setTranslation:CGPointZero inView:self.superview];
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        
        // Tell the delegate
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
    }
}


- (void) handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(cardView:willBegingRecognizingGesture:)])
        [self.delegate cardView:self willBegingRecognizingGesture:recognizer];
    
    float currentScale = sqrt(self.transform.a * self.transform.a + self.transform.c * self.transform.c);
    if (recognizer.scale >= 1.0 || (currentScale > 0.6 && recognizer.scale < 1.0)) {
        
        self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
        
        // Reset scale
        recognizer.scale = 1.0;
        
        // Tell the delegate the end of the interaction
        if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
            if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
                [self.delegate cardEndedInteracting:self];
    }
}


- (void) handleRotation:(UIRotationGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(cardView:willBegingRecognizingGesture:)])
        [self.delegate cardView:self willBegingRecognizingGesture:recognizer];
    
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    
    // Reset rotation
    recognizer.rotation = 0.0;
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
}


- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}


#pragma mark - Property implementation

- (UIImageView *) imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}


- (UIImageView *) starImageView
{
    if (_starImageView == nil) {
        _starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star"]];
        _starImageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        [self addSubview:_starImageView];
    }
    
    return _starImageView;
}


- (UIPanGestureRecognizer *) panGestureRecognizer
{
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_panGestureRecognizer];
    }
    
    return _panGestureRecognizer;
}


- (UIPinchGestureRecognizer *) pinchGestureRecognizer
{
    if (_pinchGestureRecognizer == nil) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        _pinchGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_pinchGestureRecognizer];
    }
    
    return _pinchGestureRecognizer;
}


- (UIRotationGestureRecognizer *) rotationGestureRecognizer
{
    if (_rotationGestureRecognizer == nil) {
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
        _rotationGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_rotationGestureRecognizer];
    }
    
    return _rotationGestureRecognizer;
}


- (NSMutableArray *) interactions
{
    if (_interactions == nil)
        _interactions = [NSMutableArray array];
    
    return _interactions;
}

- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.imageView.frame = bounds;
}


- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.imageView.frame = self.bounds;
}

@end
