//
//  CoreGraphicsExtention.h
//  Oficios
//
//  Created by Pablo Camiletti on 14/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#ifndef Oficios_CoreGraphicsExtention_h
#define Oficios_CoreGraphicsExtention_h


CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}


CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
{
    return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale);
}


CG_INLINE CGSize CGAffineTransformGetScale(CGAffineTransform t)
{
    return CGSizeMake(sqrt(t.a * t.a + t.c * t.c), sqrt(t.b * t.b + t.d * t.d)) ;
}


#endif
