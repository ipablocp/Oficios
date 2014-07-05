//
//  ImagePicker.m
//  Oficios
//
//  Created by Pablo Camiletti on 14/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "ImagePickerController.h"
#import "ImagePickerCell.h"


@interface ImagePickerController ()
@property (strong, nonatomic) NSMutableArray *imageNames;
@end


@implementation ImagePickerController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Selecciona una imagen";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelBarButtonItemPressed)];
    
    [self loadImageNames];
}


- (void) cancelBarButtonItemPressed
{
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
        [self.delegate imagePickerControllerDidCancel:self];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageNames.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImagePickerCell *cell = (ImagePickerCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PickerCell" forIndexPath:indexPath];
    
    NSString *imageName = self.imageNames[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.imageView.layer.minificationFilter = kCAFilterTrilinear;
    cell.imageView.layer.magnificationFilter = kCAFilterTrilinear;
    
    return cell;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingImageNamed:)])
        [self.delegate imagePickerController:self didFinishPickingImageNamed:self.imageNames[indexPath.row]];
}


#pragma mark - XML parsing

- (BOOL) loadImageNames
{
    // Parse configuration file
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"imagenes" withExtension:@"list"];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    [parser setDelegate:self];
    BOOL success = [parser parse];
    
    if (!success)
        NSLog(@"Error parsing the file imagenes.config");
    
    return success;
}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Process images
    if ([elementName isEqual:@"imagen"]) {
        NSString *imageName = [attributeDict objectForKey:@"nombre"];
        if ([imageName rangeOfString:self.imagesPrefix].location != NSNotFound)
            [self.imageNames addObject:imageName];
    }
}


// Error handling
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}


- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}


- (NSMutableArray*) imageNames
{
    if (_imageNames == nil)
        _imageNames = [NSMutableArray array];
    
    return _imageNames;
}


@end
