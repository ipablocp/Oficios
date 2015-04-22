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
#import "CoreGraphicsExtention.h"


@interface CardView ()
{
    CGFloat initialDistance;
    CGFloat deltaAngle;
    
    CGPoint lastTouchPosition;
    
    // Rotation reconnizer
    BOOL isRecognisingRotation;
}
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
    _oneFingerRotationEnable = NO;
    lastTouchPosition = CGPointMake(0.0, 1.0);
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
    float currentScale = CGAffineTransformGetScale(self.transform).width;
    
    // Limit max scale
    if ((recognizer.scale - 1.0) + currentScale > 2.0)
        return;
    
    // Limit min scale
    if ((recognizer.scale - 1.0) + currentScale < 0.6)
        return;
    
    // Tell the delegate
    if(recognizer.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(cardView:willBegingRecognizingGesture:)])
        [self.delegate cardView:self willBegingRecognizingGesture:recognizer];
    
    // Scale
    self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
    
    // Reset scale
    recognizer.scale = 1.0;
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
}


- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}


#pragma mark - One finger rotation

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.oneFingerRotationEnable) {
        CGPoint touchLocation = [[touches anyObject] locationInView:self.superview];
        
        deltaAngle = atan2(touchLocation.y - self.center.y, touchLocation.x - self.center.x) - CGAffineTransformGetAngle(self.transform);
        
        if([self.delegate respondsToSelector:@selector(cardView:willBegingRecognizingGesture:)])
            [self.delegate cardView:self willBegingRecognizingGesture:[[UIRotationGestureRecognizer alloc] init]];
    }
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesMoved:touches withEvent:event];
    
    if (self.oneFingerRotationEnable) {
        isRecognisingRotation = YES;
        
        CGPoint touchLocation = [[touches anyObject] locationInView:self.superview];
        
        float ang = atan2(touchLocation.y - self.center.y, touchLocation.x - self.center.x);
        
        float angleDiff = deltaAngle - ang;
        
        self.transform = CGAffineTransformRotate(self.transform, -CGAffineTransformGetAngle(self.transform));
        
        self.transform = CGAffineTransformRotate(self.transform, -angleDiff);
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isRecognisingRotation) {
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
        
        isRecognisingRotation = NO;
    }
    else
        [super touchesEnded:touches withEvent:event];
}


#pragma mark - Animations

- (void) animateFlickeringColorOverlay
{
    if (!_animatingColorOverlay) {
        
        _animatingColorOverlay = YES;
        
        CGImageRef overlayImage = [self.imageView.image imageWithOverlayColor:[UIColor orangeColor]].CGImage;
        CGImageRef originalImage = self.imageView.image.CGImage;
        
        CABasicAnimation *crossFadeAnimationToColor = [CABasicAnimation animationWithKeyPath:@"contents"];
        crossFadeAnimationToColor.fromValue = (__bridge id)(originalImage);
        crossFadeAnimationToColor.toValue = (__bridge id)(overlayImage);
        crossFadeAnimationToColor.duration = 1.0;
        
        CABasicAnimation *crossFadeAnimationToImage = [CABasicAnimation animationWithKeyPath:@"contents"];
        crossFadeAnimationToImage.fromValue = (__bridge id)(overlayImage);
        crossFadeAnimationToImage.toValue = (__bridge id)(originalImage);
        crossFadeAnimationToImage.duration = 1.0;
        crossFadeAnimationToImage.beginTime = crossFadeAnimationToColor.duration;
        
        CAAnimationGroup *crossFadeAnimation = [CAAnimationGroup animation];
        crossFadeAnimation.animations = @[crossFadeAnimationToColor, crossFadeAnimationToImage];
        crossFadeAnimation.repeatCount = INFINITY;
        crossFadeAnimation.duration = crossFadeAnimationToColor.duration + crossFadeAnimationToImage.duration;
        
        [self.imageView.layer addAnimation:crossFadeAnimation forKey:@"animateFlickeringColorOverlay"];
    }
}


- (void) stopAnimatingFlickeringColorOverlay
{
    if (_animatingColorOverlay) {
        
        [self.imageView.layer removeAnimationForKey:@"animateFlickeringColorOverlay"];
        
        _animatingColorOverlay = NO;
    }
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
