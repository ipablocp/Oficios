//
//  UIImage+Extensions.m
//  Oficios
//
//  Created by Pablo Camiletti on 28/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import "UIImage+Extensions.h"


@implementation UIImage (Extensions)


- (UIImage *)imageWithOverlayColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
