//
//  ImagePicker.h
//  Oficios
//
//  Created by Pablo Camiletti on 14/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ImagePickerControllerDelegate;


@interface ImagePickerController : UICollectionViewController <NSXMLParserDelegate>

@property (strong, nonatomic) NSString *imagesPrefix;
@property (weak, nonatomic) id<ImagePickerControllerDelegate> delegate;

@end


@protocol ImagePickerControllerDelegate <NSObject>

- (void) imagePickerController:(ImagePickerController *)picker didFinishPickingImageNamed:(NSString *)name;
- (void) imagePickerControllerDidCancel:(ImagePickerController *)picker;

@end
