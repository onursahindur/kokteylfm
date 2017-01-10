//
//  KFMViewController.m
//  KokteylFM
//
//  Created by Onur Şahindur on 28/12/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "KFMViewController.h"
#import "AudioManager.h"
#import "RadioListCollectionViewCell.h"
#import "ChatCollectionViewCell.h"

@interface KFMViewController () <UICollectionViewDelegate, UICollectionViewDataSource,
                                        UIWebViewDelegate, RadioListCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView                 *barView;
@property (weak, nonatomic) IBOutlet UIView                 *mediaView;
@property (weak, nonatomic) IBOutlet UICollectionView       *collectionView;
@property (weak, nonatomic) IBOutlet UIButton               *radioListButton;
@property (weak, nonatomic) IBOutlet UIButton               *chatButton;

// Media Buttons
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStationButton;
@property (weak, nonatomic) IBOutlet UIButton *prevStationButton;

@property (assign, nonatomic) NSInteger currentStationIndex;
@property (strong, nonatomic) NSURL *currentStationURL;
@property (strong, nonatomic) NSString *currentStationName;

@end

@implementation KFMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
//    self.barView.layer.cornerRadius = 20.0f;
//    self.barView.layer.masksToBounds = YES;
    
    self.mediaView.layer.cornerRadius = 10.0f;
    self.mediaView.layer.masksToBounds = YES;
    self.barView.layer.zPosition = 1.0f;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RadioListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RadioListCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ChatCollectionViewCell"];
    
    self.prevStationButton.enabled = NO;
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        RadioListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RadioListCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    else
    {
        ChatCollectionViewCell *cell = (ChatCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ChatCollectionViewCell" forIndexPath:indexPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kokteyl.fm/chat/"]];
        [cell.webView loadRequest:request];
        cell.webView.delegate = self;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
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

- (IBAction)tappedMediaButtons:(UIButton *)sender
{
    if (sender == self.playButton)
    {
        if ([AudioManager sharedInstance].playing)
        {
            [[AudioManager sharedInstance] pausePlaying];
        }
        else
        {
            [[AudioManager sharedInstance] startPlaying];
        }
        [self setPlayingButtonState:[AudioManager sharedInstance].playing];
    }
    else if (sender == self.nextStationButton)
    {
        RadioListCollectionViewCell *cell = (RadioListCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [self startPlaying:[cell nextStationURL] radioName:@""];
        self.nextStationButton.enabled = [cell hasMoreNext];
        self.prevStationButton.enabled = YES;
    }
    else if (sender == self.prevStationButton)
    {
        RadioListCollectionViewCell *cell = (RadioListCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [self startPlaying:[cell previousStationURL] radioName:@""];
        self.nextStationButton.enabled = YES;
        self.prevStationButton.enabled = [cell hasMorePrev];
    }
    [self setPlayingButtonState:[AudioManager sharedInstance].playing];
}

#pragma mark - WebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [MBProgressHUD showHUDAddedTo:webView animated:YES];
    [SVProgressHUD show];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [MBProgressHUD hideHUDForView:webView animated:YES];
    [SVProgressHUD dismiss];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [MBProgressHUD hideHUDForView:webView animated:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - RadioListCollectionViewCell Delegate
- (void)radioListCollectionViewCell:(RadioListCollectionViewCell *)cell
                     didSelectRadio:(NSURL *)radioURL
                      withRadioName:(NSString *)radioName
                withBackgroundColor:(UIColor *)color
{
    self.currentStationURL = radioURL;
    self.currentStationName = radioName;
    [self setPlayingButtonState:YES];
    self.nextStationButton.enabled = [cell hasMoreNext];
    self.prevStationButton.enabled = [cell hasMorePrev];
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:2.0 animations:^{
        weakSelf.barView.layer.backgroundColor = color.CGColor;
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
    [self startPlaying:radioURL
             radioName:radioName];
}


#pragma mark - Helpers
- (void)startPlaying:(NSURL *)radioURL
           radioName:(NSString *)radioName
{
    [[AudioManager sharedInstance] prepareToPlay:radioURL];
    [[AudioManager sharedInstance] changeNowPlayingInfo:@"Kokteyl FM"
                                               songName:radioName];
    [[AudioManager sharedInstance] startPlaying];
}

- (void)setPlayingButtonState:(BOOL)playing
{
    NSString *imageName = @"play";
    if (playing)
    {
        imageName = @"pause";
    }
    [self.playButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
