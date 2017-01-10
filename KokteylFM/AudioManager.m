//
//  AudioManager.m
//  KokteylFM
//
//  Created by Onur Şahindur on 29/12/2016.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "AudioManager.h"

@interface AudioManager () <AVAudioPlayerDelegate>

@end

@implementation AudioManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [AudioManager new];
        [((AudioManager *)sharedInstance) makeInitializationConfigurations];
    });
    return sharedInstance;
}

- (void)makeInitializationConfigurations
{
    
}

#pragma mark - Play Related
- (void)prepareToPlay:(NSURL *)radioURL
{
    if (self.player)
    {
        [self.player pause];
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(beginReceivingRemoteControlEvents)])
    {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//        [self becomeFirstResponder];
        //These two steps are important if you want the user to be able to change tracks with remote controls (you'll have to handle the remote control events yourself).
    }
    
    self.playerItem = [AVPlayerItem playerItemWithURL:radioURL];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
}

- (void)startPlaying
{
    self.playing = YES;
    [self.player play];
}

- (void)pausePlaying
{
    self.playing = NO;
    [self.player pause];
}

- (void)changeNowPlayingInfo:(NSString *)radioName
                    songName:(NSString *)songName
{
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter)
    {
        MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
        NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  radioName, MPMediaItemPropertyArtist,
                                  songName, MPMediaItemPropertyTitle,
                                  nil];
        center.nowPlayingInfo = songInfo;
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.player && [keyPath isEqualToString:@"status"])
    {
        if (self.player.status == AVPlayerStatusReadyToPlay)
        {
            
        }
        else if (self.player.status == AVPlayerStatusFailed)
        {
            // something went wrong. player.error should contain some information
        }
    }
}

@end
