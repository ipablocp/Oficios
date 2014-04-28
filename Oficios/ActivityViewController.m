//
//  ViewController.m
//  Oficios
//
//  Created by Pablo Camiletti on 11/04/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "ActivityViewController.h"

#define MIN_VERTICAL_MARGIN 50
#define MIN_HORIZONTAL_MARGIN 10

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ActivityViewController ()
@property (nonatomic, weak) UIControl *selectedObject;
@end


@implementation ActivityViewController


#pragma mark - Lifecycle
- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Parse configuration file
    NSString *nameOfFile = @"tarea_0.config";
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"tarea_0" withExtension:@"config"];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    [parser setDelegate:self];
    BOOL parsedSuccessfully = [parser parse];
    
    if (parsedSuccessfully) {
        [self arrangeSilhouettes];
        [self arrageCards];
        
        // Set image quality
        self.activityImageView.layer.minificationFilter = kCAFilterTrilinear;
        self.activityImageView.layer.magnificationFilter = kCAFilterTrilinear;
    }
    else
        NSLog(@"Error parsing the file %@", nameOfFile);
}


- (void) dealloc
{
    AudioServicesDisposeSystemSoundID(_correctSoundID);
    AudioServicesDisposeSystemSoundID(_incorrectSoundID);
}


#pragma mark - Card delegate methods

- (void) cardEndedInteracting:(CardView *)card
{
    // Clear selection
    self.selectedObject = nil;
    
    [self.silhouettes enumerateObjectsUsingBlock:^(SilhouetteButton *silhouette, NSUInteger idx, BOOL *stop) {
        
        // Check card is close to a silhouette
        if ([self distanceBetweenPoint:card.center andPoint:silhouette.center] <= self.maxAcceptableDistance) {
            
            // Check is the correct silhouette
            if (card.cardID == silhouette.silhouetteID && silhouette.hidden == NO) {
                
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
                    card.pinchGestureRecognizer.delegate = nil;
                    [card removeGestureRecognizer:card.pinchGestureRecognizer];
                    card.rotationGestureRecognizer.enabled = NO;
                    card.rotationGestureRecognizer.delegate = nil;
                    [card removeGestureRecognizer:card.rotationGestureRecognizer];
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

- (void) objectTouched:(UIControl*)sender
{
    if (self.selectedObject != nil && [self.selectedObject class] != [sender class]) {
        
        CardView *card = (CardView*)(([self.selectedObject class] == [CardView class]) ? self.selectedObject : sender);
        SilhouetteButton *silhouette = (SilhouetteButton*)(([self.selectedObject class] == [UIButton class]) ? self.selectedObject : sender);
        
        if (card.cardID == silhouette.silhouetteID) { // Correct match
            
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

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"didStartElement: %@", elementName);
    
    // Load activity image
    if ([elementName isEqual:@"tarea"])
        self.activityImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"imagen_tema_%i", [[attributeDict objectForKey:@"id"] integerValue]]];
    
    // Process Silhouettes
    else if ([elementName isEqual:@"serie"]) {
        NSString *itemsString = [attributeDict objectForKey:@"items"];
        NSArray *components = [itemsString componentsSeparatedByString:@" "];
        
        for (NSString *silIDString in components) {
            
            SilhouetteButton *silhouette = [SilhouetteButton buttonWithType:UIButtonTypeCustom];
            silhouette.silhouetteID = silIDString.intValue;
            silhouette.imageView.layer.minificationFilter = kCAFilterTrilinear;
            silhouette.imageView.layer.magnificationFilter = kCAFilterTrilinear;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sil_%i", silhouette.silhouetteID]];
            [silhouette setImage:image forState:UIControlStateNormal];
            [silhouette sizeToFit];
            
            [self.view addSubview:silhouette];
            [self.silhouettes addObject:silhouette];
            
            [silhouette addTarget:self action:@selector(objectTouched:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    // Process Cards
    else if ([elementName isEqual:@"objeto"]) {
        
        NSString *idString = [attributeDict objectForKey:@"id"];
        CardView *card = [[CardView alloc] initWithFrame:CGRectMake(.0, .0, 100, 100)];
        card.cardID = [idString integerValue];
        NSString *imageName = [NSString stringWithFormat:@"obj_%i", card.cardID];
        card.imageView.image = [UIImage imageNamed:imageName];
        
        [self.view addSubview:card];
        [self.cardViewsArray addObject:card];
        
        card.delegate = self;
        [card addTarget:self action:@selector(objectTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *EString = [attributeDict objectForKey:@"E"];
        if (EString)
            card.transform = CGAffineTransformConcat(card.transform, CGAffineTransformMakeScale(EString.floatValue, EString.floatValue));
        
        NSString *RString = [attributeDict objectForKey:@"R"];
        if (RString) {
            CGFloat radians = DEGREES_TO_RADIANS(RString.floatValue);
            card.transform = CGAffineTransformConcat(card.transform, CGAffineTransformMakeRotation(radians));
        }
        
    }
    
    // Process Correct Sound
    else if ([elementName isEqual:@"audio_recompensa"]) {
        
        NSString *audioName = [attributeDict objectForKey:@"file"];
        self.correctSoundPath = [[NSBundle mainBundle] URLForResource:audioName withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)self.correctSoundPath, &_correctSoundID);
        
    }
    
    // Process Incorrect Sound
    else if ([elementName isEqual:@"audio_incorrecto"]){
        
        self.incorrectSoundPath = [[NSBundle mainBundle] URLForResource:@"Incorrect" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)self.incorrectSoundPath, &_incorrectSoundID);
        
    }
    
    // Process Max Error Limits
    else if ([elementName isEqual:@"margenes_error_aceptados"]) {
        
        _maxAcceptableDistance = [[attributeDict objectForKey:@"T"] floatValue];
        _maxAcceptableRotation = [[attributeDict objectForKey:@"R"] floatValue];
        _maxAcceptableScale = [[attributeDict objectForKey:@"E"] floatValue];
        
    }
}


// Error handling
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XMLParser error: %@", [parseError localizedDescription]);
}


- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"XMLParser error: %@", [validationError localizedDescription]);
}


#pragma mark - Sounds

- (void) playCorrectSound
{
    AudioServicesPlaySystemSound(_correctSoundID);
}


- (void) playIncorrectSound
{
    AudioServicesPlaySystemSound(_incorrectSoundID);
}


#pragma mark - Utility methods

- (CGFloat) distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}


- (void) arrageCards
{
    // Max amount of cards will always be 6
    NSInteger rows = (self.cardViewsArray.count > 2) ? 2 : 1;
    NSInteger columns = (self.cardViewsArray.count > 2) ? round(((CGFloat)self.cardViewsArray.count) / 2.0) : 2;
    CGFloat   height = [[self.silhouettes firstObject] frame].size.height;
    CGFloat   xOrigin = self.activityImageView.frame.origin.x + self.activityImageView.frame.size.width;
    CGFloat   availableHorizontalSpace = self.view.frame.size.width - xOrigin;
    CGFloat   availableVerticalSpace = [[self.silhouettes firstObject] frame].origin.y;
    
    for (int i = 0; i < self.cardViewsArray.count; i++) {
        
        CardView *card = self.cardViewsArray[i];
        CGSize size = card.imageView.image.size;
        CGFloat proportionalWidth = size.width / size.height;
        
        // Change the bounds because the card may be rotated
        card.bounds = CGRectMake(.0, .0, proportionalWidth * height, height);
        
        // Position card
        NSInteger atRow = i / columns;
        NSInteger atColumn = i - (atRow * columns);
        card.center = CGPointMake(xOrigin + ((availableHorizontalSpace / (columns + 1)) * (atColumn + 1)),
                                  (availableVerticalSpace / (rows + 1)) * (atRow + 1) );
        card.originalCenter = card.center;
        
    }
    
}


- (void) arrangeSilhouettes
{
    NSInteger numberOfSilhouettes = self.silhouettes.count;
    
    CGFloat maxHeight = (self.view.frame.size.height - (MIN_VERTICAL_MARGIN * 4)) / 3.0;
    
    // Equalize heights
    CGFloat cumulativeWidth = 0;
    for (SilhouetteButton *silhouette in self.silhouettes) {
        
        CGSize size = silhouette.imageView.image.size;
        CGFloat proportionalWidth = size.width / size.height;
        
        silhouette.bounds = CGRectMake(.0, .0, proportionalWidth * maxHeight, maxHeight);
        
        cumulativeWidth += silhouette.bounds.size.width;
        
    }
    
    /* --  Reduce size if silhouettes don't fit  -- */
    CGFloat widthWithMargin = cumulativeWidth + (MIN_HORIZONTAL_MARGIN * (numberOfSilhouettes + 1));
    if (widthWithMargin > self.view.frame.size.width) {
        
        CGFloat availableSpace = (self.view.frame.size.width - (MIN_HORIZONTAL_MARGIN * (numberOfSilhouettes + 1)));
        for (SilhouetteButton *silhouette in self.silhouettes) {
            
            CGRect silFrame = silhouette.frame;
            CGFloat proportionalHeight = silFrame.size.height / silFrame.size.width;
            
            silFrame.size.width = (silFrame.size.width * availableSpace) / cumulativeWidth;
            silFrame.size.height = silFrame.size.width * proportionalHeight;
            silhouette.frame = silFrame;
            
        }
        
        cumulativeWidth = availableSpace;
    }
    
    /* --  Ajust positions  -- */
    SilhouetteButton *exampleSil = [self.silhouettes firstObject];
    // To spread the silhouettes horizontally:
    CGFloat availableHorizontalMarigin = (self.view.frame.size.width - cumulativeWidth) / (numberOfSilhouettes + 1);
    CGFloat horizontalMargin = (availableHorizontalMarigin > MIN_HORIZONTAL_MARGIN) ? availableHorizontalMarigin : MIN_HORIZONTAL_MARGIN;
    // The size of the silhouettes determine the size of the cards. If the silhouettes are reduced, the cards will be too and the vertical margin will increase:
    CGFloat availableVerticalMargin = (self.view.frame.size.height - (exampleSil.frame.size.height * 3)) / 4;
    CGFloat verticalMargin = (availableVerticalMargin > MIN_VERTICAL_MARGIN) ? availableVerticalMargin : MIN_VERTICAL_MARGIN;
    // Init origin vars
    CGFloat xOrigin = horizontalMargin;
    CGFloat yOrigin = (exampleSil.frame.size.height * 2) + (verticalMargin * 3.0);
    // Set origin to all silhouettes
    for (SilhouetteButton *silhouette in self.silhouettes) {
        
        CGRect silFrame = silhouette.frame;
        silFrame.origin.x = xOrigin;
        silFrame.origin.y = yOrigin;
        silhouette.frame = silFrame;
        
        xOrigin += silFrame.size.width + horizontalMargin;
        
    }
}


#pragma mark - Property implementation

- (NSInteger) numberOfCards
{
    return self.cardViewsArray.count;
}


- (NSMutableArray *)silhouettes
{
    if (_silhouettes == nil)
        _silhouettes = [NSMutableArray array];
    
    return _silhouettes;
}


- (NSMutableArray *)cardViewsArray
{
    if (_cardViewsArray == nil)
        _cardViewsArray = [NSMutableArray array];
    
    return _cardViewsArray;
}


@end
