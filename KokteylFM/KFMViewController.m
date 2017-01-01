//
//  KFMViewController.m
//  KokteylFM
//
//  Created by Onur Şahindur on 28/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "KFMViewController.h"
#import "RadioListCollectionViewCell.h"
#import "ChatCollectionViewCell.h"

@interface KFMViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView                 *barView;
@property (weak, nonatomic) IBOutlet UIView                 *mediaView;
@property (weak, nonatomic) IBOutlet UICollectionView       *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *radioListButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation KFMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.barView.layer.cornerRadius = 20.0f;
    self.barView.layer.masksToBounds = YES;
    
    self.mediaView.layer.cornerRadius = 10.0f;
    self.mediaView.layer.masksToBounds = YES;
    self.barView.layer.zPosition = 1.0f;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RadioListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RadioListCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChatCollectionViewCell"];
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RadioListCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        ChatCollectionViewCell *cell = (ChatCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ChatCollectionViewCell" forIndexPath:indexPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kokteyl.fm/chat/"]];
        [cell.webView loadRequest:request];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
}

#pragma mark - Actions
- (IBAction)tappedButton:(UIButton *)sender
{
    if (sender == self.radioListButton)
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    else
    {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}


@end
