//
//  JHDoubleFaceView.h
//  TodayWidgetsDemo
//
//  Created by 各连明 on 2016/12/9.
//  Copyright © 2016年 glm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHDoubleFaceView : UIView

@property (nonatomic, strong) UIView *frontView;//展示正面视图
@property (nonatomic, strong) UIView *backView;//展示背面视图

/*
 *为了实现正反两面显示不同的视图想了一个笨办法，就是在一个view上又放两个view分别表示正反面两个视图，又利用矩阵的3D变换，
 *将这两个view调整至合适的位置。使用的时候发现一个问题，就是将两个view放到Z轴的同一位置时就会出现正反两个view重合的现象，
 *将两个view在Z轴上稍稍错开了点位置。暂时没想到更好的办法实现这种正反面的显示视图，欢迎讨论!
 */
@property (nonatomic, assign) CGAffineTransform frontTransform;
@property (nonatomic, assign) CGAffineTransform backTransform;

@end
