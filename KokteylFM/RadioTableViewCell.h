//
//  RadioTableViewCell.h
//  KokteylFM
//
//  Created by Onur Şahindur on 29/12/2016.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface RadioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *radioImageView;
@property (weak, nonatomic) IBOutlet UILabel *radioTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *radioDescriptionLabel;

@end
