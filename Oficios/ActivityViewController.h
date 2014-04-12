//
//  ViewController.h
//  Oficios
//
//  Created by Pablo * on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CardImageView.h"


@interface ActivityViewController : UIViewController

// Data
@property (nonatomic, readonly) NSInteger numberOfCards;
@property (nonatomic, readonly) NSInteger numberOfSilhouettes;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (strong, nonatomic) IBOutletCollection(CardImageView) NSArray *cardImageViewsArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *silhouettes;

@end
