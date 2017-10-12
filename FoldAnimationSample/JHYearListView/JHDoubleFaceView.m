//
//  JHDoubleFaceView.m
//  TodayWidgetsDemo
//
//  Created by 各连明 on 2016/12/9.
//  Copyright © 2016年 glm. All rights reserved.
//

#import "JHDoubleFaceView.h"

@interface JHDoubleFaceView ()

@end

@implementation JHDoubleFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrontView:(UIView *)frontView {
    if(frontView){
        _frontView = frontView;
        _frontView.frame = self.bounds;
        [self addSubview:_frontView];
        [self bringSubviewToFront:_frontView];
        _frontView.layer.transform = CATransform3DMakeTranslation(0, 0, 0.0000001);
    }
}

- (void)setBackView:(UIView *)backView {
    if(backView){
        _backView = backView;
        _backView.frame = self.bounds;
        [self addSubview:_backView];
        [self sendSubviewToBack:_backView];
        _backView.layer.transform = CATransform3DMakeTranslation(0, 0, -0.0000001);
    }
}

- (void)setFrontTransform:(CGAffineTransform)frontTransform {
    if(_frontView){
        _frontView.transform = frontTransform;
    }
}

- (void)setBackTransform:(CGAffineTransform)backTransform {
    if(_backView){
        _backView.transform = backTransform;
    }
}

@end
