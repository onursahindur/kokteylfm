//
//  AudioManager.h
//  KokteylFM
//
//  Created by Onur Şahindur on 29/12/2016.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AudioManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) AVPlayer          *player;
@property (nonatomic, strong) AVPlayerItem      *playerItem;

@property (nonatomic, assign) BOOL playing;

- (void)prepareToPlay:(NSURL *)radioURL;
- (void)startPlaying;
- (void)pausePlaying;
- (void)changeNowPlayingInfo:(NSString *)radioName
                    songName:(NSString *)songName
                   imageName:(NSString *)radioImageName;

@end
