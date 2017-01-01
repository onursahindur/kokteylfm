//
//  RadioTableViewCell.m
//  KokteylFM
//
//  Created by Onur Şahindur on 29/12/2016.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "RadioTableViewCell.h"

@implementation RadioTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.radioImageView.layer.cornerRadius = self.radioImageView.frame.size.width / 2;
    self.radioImageView.clipsToBounds = YES;
}

@end
