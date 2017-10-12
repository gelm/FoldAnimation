//
//  JHYearListView.h
//  TodayWidgetsDemo
//
//  Created by 各连明 on 2016/12/6.
//  Copyright © 2016年 glm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHYearListView;

@protocol JHYearListViewDelegate <NSObject>

@optional
- (void)yearListView:(JHYearListView *)yearListView didSelected:(NSString *)year;

@end

@interface JHYearListView : UIView

@property (nonatomic, weak) id<JHYearListViewDelegate>delegate;
@property (nonatomic, assign) NSInteger defaultIndex;

- (void)showAnimationInView:(UIView *)view;

- (NSInteger)indexWithYear:(NSInteger)year;

@end
