//
//  ViewController.m
//  Oficios
//
//  Created by Pablo * on 11/04/14.
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
    _numberOfCards = 6;
    _numberOfSilhouettes = 3;
    _maxAcceptableDistance = 30.0;
    _maxAcceptableRotation = 25.0;
    //_maxAcceptableScale = ;
    
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
}


#pragma mark - Card delegate methods

- (void)cardEndedInteracting:(CardView *)card
{
    [self.silhouettes enumerateObjectsUsingBlock:^(UIButton *silhouette, NSUInteger idx, BOOL *stop) {
        
        // Check card is close to a silhouette
        if ([self distanceBetweenPoint:card.center andPoint:silhouette.center] <= self.maxAcceptableDistance) {
            
            // Check is the correct silhouette
            NSInteger silhouetteID = [self.silhouetteSequence[idx] integerValue];
            if (card.cardID == silhouetteID) {
                
                // Lock position
                card.panGestureRecognizer.enabled = NO;
                
                [UIView animateWithDuration:.6 delay:.0 usingSpringWithDamping:.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    card.center = silhouette.center;
                    
                } completion:^(BOOL finished) {
                    
                    // Star explotion
                    
                    // Fixed star
                    
                }];
            }
            else {
                // Error sound
                
                [card flashCardWithColor:[UIColor redColor]];
                
                // Move to original place
                [UIView animateWithDuration:1.0 delay:.0 usingSpringWithDamping:.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    [card moveToOriginalPosition];
                    
                } completion:nil];
                
            }
        }
        
    }];
}


- (IBAction) objectTouched:(UIControl*)sender
{
    if (self.selectedObject != nil && [self.selectedObject class] != [sender class]) {
        
        CardView *card       = (CardView*)(([self.selectedObject class] == [CardView class]) ? self.selectedObject : sender);
        UIButton *silhouette = (UIButton*)(([self.selectedObject class] == [UIButton class]) ? self.selectedObject : sender);
        
        NSInteger index = [self.silhouettes indexOfObject:silhouette];
        if (card.cardID == [self.silhouetteSequence[index] integerValue]) { // Correct match
            
            // Lock card movement
            card.panGestureRecognizer.enabled = NO;
            
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


#pragma mark - XML parsing
/*
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"serie items"])
    {
        event.id = currentNodeContentChapters;
    }
}
*/


- (CGFloat) distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}


@end
