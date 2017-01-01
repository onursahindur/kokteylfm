//
//  RadioListCollectionViewCell.m
//  KokteylFM
//
//  Created by Onur Şahindur on 29/12/2016.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "RadioListCollectionViewCell.h"
#import "AudioManager.h"
#import "RadioTableViewCell.h"

@interface RadioListCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RadioListCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.radioTitleList = @[@"EG Radyo", @"AnatolianFunk", @"TalkyRadio", @"Hypenoise", @"Reklamsız Türk Sanat"].mutableCopy;
    self.radioURLList = @[@"https://kokteyl.fm/egradyo.pls", @"https://kokteyl.fm/anatolianfunk.pls", @"https://kokteyl.fm/talkyradio.pls", @"https://kokteyl.fm/hypenoise.pls", @"https://kokteyl.fm/reklamsizturksanat.pls"].mutableCopy;
    self.radioImageViewList = @[@"egradio_logo", @"anatolianradio_logo", @"talkyradio_logo", @"hypenoise_logo", @"sanatradio_logo"].mutableCopy;
    self.radioHexColorList = @[@"#b01719", @"#d0457e", @"#28b7c0", @"#2a2a2a", @"#5a3006"].mutableCopy;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"RadioTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.radioTitleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioTableViewCell"
                                                            forIndexPath:indexPath];
    cell.backgroundColor = [self colorFromHexString:self.radioHexColorList[indexPath.row]];
    NSString *imageName = [NSString stringWithFormat:@"%@", self.radioImageViewList[indexPath.row]];
    cell.radioImageView.image = [UIImage imageNamed:imageName];
    cell.radioTitleLabel.text = self.radioTitleList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *radioURLString = self.radioURLList[indexPath.row];
    [[AudioManager sharedInstance] prepareToPlay:[NSURL URLWithString:radioURLString]];
    [[AudioManager sharedInstance] changeNowPlayingInfo:self.radioTitleList[indexPath.row]
                                               songName:@"SONG"];
    [[AudioManager sharedInstance] startPlaying];
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
