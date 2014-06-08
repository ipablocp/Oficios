//
//  SettingsTableViewCell.m
//  Oficios
//
//  Created by Pablo Camiletti on 08/06/14.
//  Copyright (c) 2014 DSIC. All rights reserved.
//


#import "SettingsTableViewCell.h"


@implementation SettingsTableViewCell


- (void)awakeFromNib
{
    [self addSubview:self.switchControl];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void) switchControlPressed:(UISwitch*)sender
{
    if ([self.delegate respondsToSelector:@selector(switchDidChangeInCell:)])
        [self.delegate switchDidChangeInCell:self];
}


- (UISwitch *) switchControl
{
    if (_switchControl == nil){
        _switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(471.0, 6.0, 51.0, 31.0)];
        [_switchControl addTarget:self action:@selector(switchControlPressed:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _switchControl;
}


@end
