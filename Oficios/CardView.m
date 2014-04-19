//
//  CardImageView.m
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "CardView.h"

@implementation CardView


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
    // Set image quality
    self.imageView.layer.magnificationFilter = kCAFilterTrilinear;
    self.imageView.layer.minificationFilter = kCAFilterTrilinear;
    self.imageView.layer.shouldRasterize = YES;
}


#pragma mark - Actions

- (void) flashCardWithColor:(UIColor*)color
{
    CIImage *ciImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"
                                  keysAndValues: @"inputImage", ciImage,
                                                 @"inputColor0", [CIColor colorWithCGColor:color.CGColor],
                                                 @"inputColor1", [CIColor colorWithCGColor:color.CGColor], nil];
    
    CIImage *outputImage = [filter outputImage];
    
    UIImage *coloredImage = [UIImage imageWithCIImage:outputImage];
    
    UIImage *originalImage = self.imageView.image;
    [UIView transitionWithView:self.imageView duration:.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.imageView.image = coloredImage;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [UIView transitionWithView:self.imageView duration:.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.imageView.image = originalImage;
                
            } completion:nil];
            
        }
       
        
    }];
}


- (void) moveToOriginalPosition
{
    self.center = self.originalCenter;
}


#pragma mark - Gestures handlers

- (IBAction)handlePan:(UIPanGestureRecognizer*)recognizer
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


- (IBAction)handleRotation:(UIRotationGestureRecognizer*)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    
    // Reset rotation
    recognizer.rotation = 0.0;
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
}


- (IBAction)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
    
    // Reset scale
    recognizer.scale = 1.0;
    
    // Tell the delegate the end of the interaction
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        if ([self.delegate respondsToSelector:@selector(cardEndedInteracting:)])
            [self.delegate cardEndedInteracting:self];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - Property implementation

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}


- (UIImageView *)starImageView
{
    if (_starImageView == nil) {
        _starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star"]];
        _starImageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        [self addSubview:_starImageView];
    }
    
    return _starImageView;
}



@end
