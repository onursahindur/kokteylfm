//
//  RadioListCollectionViewCell.m
//  KokteylFM
//
//  Created by Onur Şahindur on 29/12/2016.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "RadioListCollectionViewCell.h"
#import "RadioTableViewCell.h"

@interface RadioListCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger currentStationIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewWidthConstraint;


@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *radioDescriptionLabel;

@end

@implementation RadioListCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.radioTitleList = @[@"EG Radyo", @"AnatolianFunk", @"TalkyRadio", @"Hypenoise", @"Reklamsız Türk Sanat"].mutableCopy;
    self.radioDescriptionList = @[@"\"Sadece Kaliteli Müzik\"", @"AnatolianFunk", @"TalkyRadio", @"Hypenoise", @"Reklamsız!"].mutableCopy;
    self.radioURLList = @[@"https://kokteyl.fm/egradyo.pls", @"https://kokteyl.fm/anatolianfunk.pls", @"https://kokteyl.fm/talkyradio.pls", @"https://kokteyl.fm/hypenoise.pls", @"https://kokteyl.fm/reklamsizturksanat.pls"].mutableCopy;
    self.radioImageViewList = @[@"egradio_logo", @"anatolianradio_logo", @"talkyradio_logo", @"hypenoise_logo", @"sanatradio_logo"].mutableCopy;
    self.radioHexColorList = @[@"#b01719", @"#d0457e", @"#28b7c0", @"#2a2a2a", @"#5a3006"].mutableCopy;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"RadioTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewHeightConstraint.constant = 70 * self.radioURLList.count;
    
    self.currentStationIndex = 0;
    
    if (IS_IPHONE_4)
    {
        self.logoImageViewHeightConstraint.constant = 50.0f;
        self.logoImageViewWidthConstraint.constant  = 50.0f;
    }
    if (IS_IPHONE_5)
    {
        self.logoImageViewHeightConstraint.constant = 75.0f;
        self.logoImageViewWidthConstraint.constant  = 75.0f;
    }
    
    self.logoImageView.layer.cornerRadius = self.logoImageViewWidthConstraint.constant / 2;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.borderWidth = 5.0f;
    self.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.layer.backgroundColor = [self colorFromHexString:[self.radioHexColorList firstObject]].CGColor;
    [self.radioDescriptionLabel setText:[self.radioDescriptionList firstObject]];
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
    self.currentStationIndex = indexPath.row;
    [self animateUIWithIndex:indexPath.row];
    
    NSString *radioURLString = self.radioURLList[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(radioListCollectionViewCell:
                                                    didSelectRadio:
                                                    withRadioName:
                                                    imageName:
                                                    withBackgroundColor:)])
    {
        [self.delegate radioListCollectionViewCell:self
                                    didSelectRadio:[NSURL URLWithString:radioURLString]
                                     withRadioName:self.radioTitleList[indexPath.row]
                                         imageName:self.radioImageViewList[indexPath.row]
                               withBackgroundColor:[self colorFromHexString:self.radioHexColorList[indexPath.row]]];
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - public
- (NSURL *)currentStationURL
{
    return [NSURL URLWithString:self.radioURLList[self.currentStationIndex]];
}

- (NSURL *)nextStationURL
{
    if (self.currentStationIndex == self.radioURLList.count - 1)
    {
        return nil;
    }
    self.currentStationIndex++;
    [self animateUIWithIndex:self.currentStationIndex];
    return [NSURL URLWithString:self.radioURLList[self.currentStationIndex]];
}

- (NSURL *)previousStationURL
{
    if (self.currentStationIndex == 0)
    {
        return nil;
    }
    self.currentStationIndex--;
    [self animateUIWithIndex:self.currentStationIndex];
    return [NSURL URLWithString:self.radioURLList[self.currentStationIndex]];
}

- (NSString *)currentStationTitle
{
    return [self.radioTitleList objectAtIndex:self.currentStationIndex];
}

- (NSString *)currentStationImage
{
    return [self.radioImageViewList objectAtIndex:self.currentStationIndex];
}

- (BOOL)hasMoreNext
{
    if (self.currentStationIndex == self.radioURLList.count - 1)
    {
        return NO;
    }
    return YES;
}

- (BOOL)hasMorePrev
{
    if (self.currentStationIndex == 0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - private
- (void)animateUIWithIndex:(NSInteger)index
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:1.5f animations:^{
        weakSelf.layer.backgroundColor = [weakSelf colorFromHexString:weakSelf.radioHexColorList[index]].CGColor;
        [weakSelf layoutIfNeeded];
    } completion:nil];
    
    [UIView transitionWithView:self.logoImageView
                      duration:1.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [weakSelf.logoImageView setImage:[UIImage imageNamed:weakSelf.radioImageViewList[index]]];
                        [weakSelf layoutIfNeeded];
                    } completion:nil];
    
    [UIView transitionWithView:self.radioDescriptionLabel
                      duration:1.5f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [weakSelf.radioDescriptionLabel setText:weakSelf.radioDescriptionList[index]];
                        [weakSelf layoutIfNeeded];
                    } completion:nil];
}

@end
