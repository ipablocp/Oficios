//
//  CardImageView.m
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "CardView.h"
#import "UIImage+Extensions.h"


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
    
    // Init gestures
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    self.rotationGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.rotationGestureRecognizer];
    
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    self.pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.pinchGestureRecognizer];
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


#pragma mark - Gestures handlers

- (void) handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.superview];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    
    // Reset translation
    [recognizer setTranslation:CGPointZero inView:self.superview];
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
}


- (void) handleRotation:(UIRotationGestureRecognizer*)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    
    // Reset rotation
    recognizer.rotation = 0.0;
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
}


- (void) handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
    
    // Reset scale
    recognizer.scale = 1.0;
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
}


- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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


- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.imageView.frame = bounds;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.imageView.frame = self.bounds;
}

@end
