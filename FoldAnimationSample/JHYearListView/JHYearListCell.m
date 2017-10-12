//
//  JHYearListCell.m
//  TodayWidgetsDemo
//
//  Created by 各连明 on 2016/12/6.
//  Copyright © 2016年 glm. All rights reserved.
//

#import "JHYearListCell.h"

@interface JHYearListCell ()

@end

@implementation JHYearListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _bottomImageView = [[UIImageView alloc]init];
        _bottomImageView.frame = CGRectMake(0,  CGRectGetHeight(self.bounds)/2 - 70, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds) - 40);
        [self addSubview:_bottomImageView];
        
        _topImageView = [[UIImageView alloc]init];
        _topImageView.layer.anchorPoint = CGPointMake(0.5, 0);
        _topImageView.frame = CGRectMake(0,  CGRectGetHeight(self.bounds)/2 - 70, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds) - 40);
        [self addSubview:_topImageView];
        
        _yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_bottomImageView.frame) - 82, CGRectGetWidth(frame), 44)];
        _yearLabel.font = [UIFont boldSystemFontOfSize:40];
        _yearLabel.textColor = [UIColor whiteColor];
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_yearLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];
    if([_delegate respondsToSelector:@selector(clickCell:)] && CGRectContainsPoint(_bottomImageView.frame, location)){
        [_delegate clickCell:self];
    }
}

@end
