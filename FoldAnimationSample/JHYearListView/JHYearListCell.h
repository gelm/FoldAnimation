//
//  JHYearListCell.h
//  TodayWidgetsDemo
//
//  Created by 各连明 on 2016/12/6.
//  Copyright © 2016年 glm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHYearListCell;

@protocol JHYearListCellDelegate <NSObject>

@optional
- (void)clickCell:(JHYearListCell *)cell;

@end

@interface JHYearListCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, weak) id<JHYearListCellDelegate>delegate;

@end
