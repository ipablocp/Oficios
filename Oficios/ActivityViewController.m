//
//  ViewController.m
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "ActivityViewController.h"

@interface ActivityViewController ()
@property (nonatomic, weak) UIControl *selectedObject;
@end


@implementation ActivityViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Set image quality
    self.activityImageView.layer.minificationFilter = kCAFilterTrilinear;
    self.activityImageView.layer.magnificationFilter = kCAFilterTrilinear;
    for (UIButton *silhouette in self.silhouettes) {
        silhouette.imageView.layer.minificationFilter = kCAFilterTrilinear;
        silhouette.imageView.layer.magnificationFilter = kCAFilterTrilinear;
    }
    
    // Set self as card's delegate
    for (CardView *card in self.cardViewsArray) {
        card.delegate = self;
        [card addTarget:self action:@selector(objectTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Parse configuration file
    /*
    NSString *nameOfFile = @"tarea_1.config";
    NSURL *fileURL = [[NSURL alloc] initWithString:nameOfFile];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    [parser setDelegate:self];
    BOOL parsedSuccessfully = [parser parse];
    */
    
    //if (parsedSuccessfully)
        [self loadActivity];
    //else
    //    NSLog(@"Error parsing the file %@", nameOfFile);
}


- (void) loadActivity
{
    _numberOfCards          = 6;
    _numberOfSilhouettes    = 3;
    _maxAcceptableDistance  = 30.0;
    _maxAcceptableRotation  = 25.0;
    _maxAcceptableScale     = 1.2;
    
    // Load activity image
    self.activityImageView.image = [UIImage imageNamed:@"imagen_tema"];
    
    // Load images
    for (int i = 0; i < self.numberOfCards; i++) {
        CardView *card = self.cardViewsArray[i];
        card.cardID = i;
        //card.center = ;
        card.originalCenter = card.center;
        card.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"obj_%i", i]];
        
        card.transform = CGAffineTransformMakeRotation(arc4random()%360);
    }
    
    // Load sequence
    self.silhouetteSequence = [NSMutableArray arrayWithCapacity:self.numberOfSilhouettes];
    for (int i = 0; i < self.numberOfSilhouettes; i++)
        self.silhouetteSequence[i] = @(i);
    
    // Load silhouettes
    for (int i = 0; i < self.numberOfSilhouettes; i++) {
        UIButton *silhouette = self.silhouettes[i];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sil_%i", i]];
        [silhouette setImage:image forState:UIControlStateNormal];
    }
    
    // Sounds
    self.correctSoundPath = [[NSBundle mainBundle] URLForResource:@"Correct" withExtension:@"wav"];
    self.incorrectSoundPath = [[NSBundle mainBundle] URLForResource:@"Incorrect" withExtension:@"wav"];
}


#pragma mark - Card delegate methods

- (void)cardEndedInteracting:(CardView *)card
{
    // Clear selection
    self.selectedObject = nil;
    
    [self.silhouettes enumerateObjectsUsingBlock:^(UIButton *silhouette, NSUInteger idx, BOOL *stop) {
        
        // Check card is close to a silhouette
        if ([self distanceBetweenPoint:card.center andPoint:silhouette.center] <= self.maxAcceptableDistance) {
            
            // Check is the correct silhouette
            NSInteger silhouetteID = [self.silhouetteSequence[idx] integerValue];
            if (card.cardID == silhouetteID) {
                
                if( !CGPointEqualToPoint(card.center, silhouette.center) ){
                    
                    // Lock position
                    card.panGestureRecognizer.enabled = NO;
                    silhouette.userInteractionEnabled = NO;
                    [card removeTarget:self action:@selector(objectTouched:) forControlEvents:UIControlEventTouchUpInside];
                    [silhouette removeTarget:self action:@selector(objectTouched:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [UIView animateWithDuration:.6 delay:.0 usingSpringWithDamping:.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        card.center = silhouette.center;
                        
                    } completion:nil];
                    
                }
                
                if ([self hasCardProperRotationAndScale:card]) {
                    
                    // Disable rest of interaction
                    card.pinchGestureRecognizer.enabled = NO;
                    card.rotationGestureRecognizer.enabled = NO;
                    silhouette.hidden = YES;
                    
                    // Finish alignment
                    [UIView animateWithDuration:.3 animations:^{
                        card.transform = CGAffineTransformIdentity;
                    }];
                    
                    // Star explotion
                    
                    // Correct sound
                    [self playCorrectSound];
                    
                    // Fix star
                    card.starImageView.transform = CGAffineTransformMakeScale(.0, .0);
                    [UIView animateWithDuration:.3 animations:^{
                        card.starImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                }
                
            }
            else {
                // Error sound
                [self playIncorrectSound];
                
                [card flashCardWithColor:[UIColor redColor]];
                
                // Move to original place
                [UIView animateWithDuration:1.0 delay:.0 usingSpringWithDamping:.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    [card moveToOriginalPosition];
                    
                } completion:nil];
                
            }
        }
        
    }];
}


#pragma mark - Matching touching silhouette and card

- (IBAction) objectTouched:(UIControl*)sender
{
    if (self.selectedObject != nil && [self.selectedObject class] != [sender class]) {
        
        CardView *card       = (CardView*)(([self.selectedObject class] == [CardView class]) ? self.selectedObject : sender);
        UIButton *silhouette = (UIButton*)(([self.selectedObject class] == [UIButton class]) ? self.selectedObject : sender);
        
        NSInteger index = [self.silhouettes indexOfObject:silhouette];
        if (card.cardID == [self.silhouetteSequence[index] integerValue]) { // Correct match
            
            // Lock card movement
            card.panGestureRecognizer.enabled = NO;
            [card removeTarget:self action:@selector(objectTouched:) forControlEvents:UIControlEventTouchUpInside];
            [silhouette removeTarget:self action:@selector(objectTouched:) forControlEvents:UIControlEventTouchUpInside];
            
            // Move card
            [UIView animateWithDuration:.6 delay:.0 usingSpringWithDamping:.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                card.center = silhouette.center;
                
            } completion:nil];
            
        }
        else { // Incorrect match
            
            // Error sound
            
        }
        
        // Unhighlight booth card and silhouette
        
        self.selectedObject = nil;
    }
    else {
        // highlight sender
        
        // unhighlight selected object
        
        self.selectedObject = sender;
    }
}


- (BOOL) hasCardProperRotationAndScale:(CardView*)card
{
    CGFloat rotation = fabs((180 * (atan2(card.transform.b, card.transform.a))) / M_PI);
    CGFloat scale = sqrt((card.transform.a * card.transform.a) + (card.transform.c * card.transform.c));
    NSLog(@"rotation angle = %f, scale = %f", rotation, scale);

    if ((rotation <= self.maxAcceptableRotation || 360 - rotation <= self.maxAcceptableRotation) &&
        (scale <= self.maxAcceptableScale))
        return YES;
    else
        return NO;
}


#pragma mark - XML parsing
/*
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"serie items"])
    {
        event.id = currentNodeContentChapters;
    }
}
*/


#pragma mark - Sounds

- (void) playCorrectSound
{
    SystemSoundID correctSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)self.correctSoundPath, &correctSoundID);
    AudioServicesPlaySystemSound(correctSoundID);
    //AudioServicesDisposeSystemSoundID(correctSoundID);
}


- (void) playIncorrectSound
{
    SystemSoundID incorrectSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)self.incorrectSoundPath, &incorrectSoundID);
    AudioServicesPlaySystemSound(incorrectSoundID);
    //AudioServicesDisposeSystemSoundID(incorrectSoundID);
}


#pragma mark - Utility methods

- (CGFloat) distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}


- (CAEmitterLayer*)fireworksEmitter
{
    if (_fireworksEmitter == nil) {
        
        _fireworksEmitter = [CAEmitterLayer layer];
        CGRect viewBounds = self.view.layer.bounds;
        _fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height/2);
        _fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);
        _fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
        _fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
        _fireworksEmitter.renderMode	= kCAEmitterLayerAdditive;
        _fireworksEmitter.seed = (arc4random()%100)+1;
        
        CAEmitterCell* spark = [CAEmitterCell emitterCell];
        
        spark.birthRate			= 400;
        spark.velocity			= 125;
        spark.emissionRange		= 2* M_PI;	// 360 deg
        spark.yAcceleration		= 75;		// gravity
        spark.lifetime			= 3;
        
        spark.contents			= (id) [[UIImage imageNamed:@"Star.png"] CGImage];
        spark.scaleSpeed		=-0.2;
        spark.greenSpeed		=-0.1;
        spark.redSpeed			= 0.4;
        spark.blueSpeed			=-0.1;
        spark.alphaSpeed		=-0.25;
        spark.spin				= 2* M_PI;
        spark.spinRange			= 2* M_PI;
        
        _fireworksEmitter.emitterCells = @[spark];
        
    }
    
    return _fireworksEmitter;
}


@end
