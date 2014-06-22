//
//  SilhouetteButton.m
//  Oficios
//
//  Created by Pablo Camiletti on 19/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "SilhouetteButton.h"
#import "UIImage+Extensions.h"


@implementation SilhouetteButton


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.layer.magnificationFilter = kCAFilterTrilinear;
        self.imageView.layer.minificationFilter = kCAFilterTrilinear;
    }
    return self;
}


- (void) flashCardWithColor:(UIColor*)color
{
    UIImage *originalImage = self.imageView.image;
    
    self.imageView.image = [originalImage imageWithOverlayColor:color];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.imageView.image = originalImage;
        
    });
}


@end
