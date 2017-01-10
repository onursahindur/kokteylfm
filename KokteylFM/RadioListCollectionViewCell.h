//
//  RadioListCollectionViewCell.h
//  KokteylFM
//
//  Created by Onur Şahindur on 29/12/2016.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@class RadioListCollectionViewCell;
@protocol RadioListCollectionViewCellDelegate <NSObject>

- (void)radioListCollectionViewCell:(RadioListCollectionViewCell *)cell
                     didSelectRadio:(NSURL *)radioURL
                      withRadioName:(NSString *)radioName
                withBackgroundColor:(UIColor *)color;

@end

@interface RadioListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSMutableArray *radioTitleList;
@property (strong, nonatomic) NSMutableArray *radioURLList;
@property (strong, nonatomic) NSMutableArray *radioImageViewList;
@property (strong, nonatomic) NSMutableArray *radioHexColorList;

@property (weak, nonatomic) id <RadioListCollectionViewCellDelegate> delegate;

- (NSURL *)currentStationURL;
- (NSURL *)nextStationURL;
- (NSURL *)previousStationURL;
- (BOOL)hasMoreNext;
- (BOOL)hasMorePrev;

@end
