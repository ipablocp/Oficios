//
//  ViewController.m
//  Oficios
//
//  Created by Pablo * on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "ActivityViewController.h"


@implementation ActivityViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Image quality
    self.activityImageView.layer.minificationFilter = kCAFilterTrilinear;
    self.activityImageView.layer.magnificationFilter = kCAFilterTrilinear;
    for (UIImageView *silhouette in self.silhouettes) {
        silhouette.layer.minificationFilter = kCAFilterTrilinear;
        silhouette.layer.magnificationFilter = kCAFilterTrilinear;
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadActivity];
}


- (void) loadActivity
{
    _numberOfCards = 6;
    _numberOfSilhouettes = 3;
    
    // Load activity image
    self.activityImageView.image = [UIImage imageNamed:@"imagen_tema"];
    
    // Load images
    for (int i = 0; i < self.numberOfCards; i++) {
        CardImageView *card = self.cardImageViewsArray[i];
        card.image = [UIImage imageNamed:[NSString stringWithFormat:@"obj_%i", i]];
    }
    
    // Position images
    
    
    // Load silhouettes
    for (int i = 0; i < self.numberOfSilhouettes; i++) {
        UIImageView *silhouette = self.silhouettes[i];
        silhouette.image = [UIImage imageNamed:[NSString stringWithFormat:@"sil_%i", i]];
    }
}



@end
