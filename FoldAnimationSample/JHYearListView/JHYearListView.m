//
//  JHYearListView.m
//  TodayWidgetsDemo
//
//  Created by 各连明 on 2016/12/6.
//  Copyright © 2016年 glm. All rights reserved.
//

#import "JHYearListView.h"
#import "JHYearListCell.h"

#import "JHDoubleFaceView.h"

#define animationDuration 0.65

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface JHYearListView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JHYearListCellDelegate>
{
    CGFloat _cellWidth;
    CGFloat _lineSpace;
    NSTimeInterval _lastTime;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) JHYearListCell *currentCell;

@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, strong) UIView *topFromView;
@property (nonatomic, strong) UIView *bottomFromView;

@end

@implementation JHYearListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        
        _cellWidth = CGRectGetWidth(self.bounds) - 80;
        _lineSpace = 10;
        
        _rows = [NSMutableArray array];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(_cellWidth, CGRectGetHeight(self.bounds) - 20);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 40, 0, 40);
        flowLayout.minimumLineSpacing = _lineSpace;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JHYearListCell class] forCellWithReuseIdentifier:@"JHYearListCell"];
        [self addSubview:_collectionView];
        
        [self configDatasource];
        
        UIImage *image = [UIImage imageNamed:@"year_select_back_image.jpg"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat imageViewWidth = image.size.width/2;
        imageView.frame = (CGRect){0,0,imageViewWidth, CGRectGetHeight(_collectionView.bounds)};
        _imageScrollView = [[UIScrollView alloc]initWithFrame:_collectionView.bounds];
        _imageScrollView.contentSize = CGSizeMake(imageViewWidth, CGRectGetHeight(_collectionView.bounds));
        _imageScrollView.backgroundColor = UIColorFromRGB(0x898480);
        _imageScrollView.scrollEnabled = NO;
        [_imageScrollView addSubview:imageView];
        _collectionView.backgroundView = _imageScrollView;
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"yearList_back_image"] forState:UIControlStateNormal];
        [_backButton sizeToFit];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_backButton.bounds) - 12, 40, CGRectGetWidth(_backButton.bounds), CGRectGetHeight(_backButton.bounds));
        [self addSubview:_backButton];
    
    }
    return self;
}

- (void)setDefaultIndex:(NSInteger)defaultIndex {
    if(defaultIndex <= 0){
        _defaultIndex = 0;
    }else if (defaultIndex >= _rows.count - 1){
        _defaultIndex = _rows.count - 1;
    }else{
        _defaultIndex = defaultIndex;
    }
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:_defaultIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    _currentIndex = _defaultIndex;
    
    if(_defaultIndex == _rows.count - 1){
        _imageScrollView.contentOffset = CGPointMake(_imageScrollView.contentSize.width - CGRectGetWidth(_collectionView.bounds), 0);
        _backButton.hidden = YES;
    }
}

- (NSInteger)indexWithYear:(NSInteger)year {
    NSInteger index = 0;
    for(NSInteger i=0;i<_rows.count;i++){
        NSNumber *yearNumber = _rows[i];
        if(yearNumber.integerValue == year){
            index = i;
            break;
        }
    }
    return index;
}

- (void)backAction:(UIButton *)button {
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:(_rows.count - 1) inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _currentIndex = indexpath.item;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JHYearListCell *cell = [self collectionView:_collectionView cellForItemAtIndexPath:indexpath];
        [self clickCell:cell];
    });
}

- (void)configDatasource {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *yearString = [dateFormatter stringFromDate:[NSDate new]];
    NSInteger year = [yearString integerValue];
    [_rows addObject:@(year)];
    for(NSInteger i=year;i>1994;i--){
        [_rows insertObject:@(--year) atIndex:0];
    }
    [_collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _rows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHYearListCell *cell = (JHYearListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"JHYearListCell" forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.delegate = self;
    NSNumber *year = _rows[indexPath.item];
    cell.yearLabel.text = [NSString stringWithFormat:@"%@",year];
    cell.topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"year_select_image%@",year]];
    cell.bottomImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"year_select_image%@",year]];;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentX = (_imageScrollView.contentSize.width - CGRectGetWidth(_collectionView.bounds)) * scrollView.contentOffset.x/(scrollView.contentSize.width - CGRectGetWidth(_collectionView.bounds));
    _imageScrollView.contentOffset = CGPointMake(contentX, scrollView.contentOffset.y);
    
    if(scrollView.contentOffset.x <= (scrollView.contentSize.width - CGRectGetWidth(_collectionView.bounds) - (_cellWidth - 30 + 40))){
        _backButton.hidden = NO;
    }else{
        _backButton.hidden = YES;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset {
    CGFloat pageSize = _cellWidth + _lineSpace;
    NSInteger page = roundf(offset.x / pageSize);
    _currentIndex = page;
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

#pragma mark --animations

- (void)showAnimationInView:(UIView *)view {
    _fromView = view;
    [view addSubview:self];
    [self closeAnimation];
}
/**
 *  以下的开合动画，都是一系列动画的组合才完成的，需要耐心的调试
 *
 */
- (void)closeAnimation {
    _topFromView = [_fromView resizableSnapshotViewFromRect:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    _bottomFromView = [_fromView resizableSnapshotViewFromRect:CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    
    JHDoubleFaceView *bottomView = [[JHDoubleFaceView alloc]initWithFrame:CGRectZero];
    bottomView.layer.anchorPoint = CGPointMake(0.5, 0);
    bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)/2, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2);
    bottomView.frontView = _bottomFromView;
    NSNumber *year = _rows[_currentIndex];
    bottomView.backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"year_select_image%@",year]]];
    [self addSubview:bottomView];
    
    JHDoubleFaceView *topView = [[JHDoubleFaceView alloc]initWithFrame:CGRectZero];
    topView.layer.anchorPoint = CGPointMake(0.5, 1);
    topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2);
    topView.frontView = _topFromView;
    NSNumber *year1 = _rows[_currentIndex];
    topView.backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"year_select_image%@",year1]]];
    topView.backTransform = CATransform3DGetAffineTransform(CATransform3DMakeRotation(M_PI, 1, 0, 0));
    [self addSubview:topView];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect rect = topView.frame;
        rect.origin.y -= 70;
        topView.frame = rect;
        
        rect = bottomView.frame;
        rect.origin.y -= 70;
        bottomView.frame = rect;

    } completion:^(BOOL finished) {
        _currentCell.topImageView.hidden = NO;
        _currentCell.bottomImageView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            topView.hidden = YES;
            bottomView.hidden = YES;
        } completion:^(BOOL finished) {
            [topView removeFromSuperview];
            [bottomView removeFromSuperview];
        }];

    }];
    
    CGFloat scaleX = _cellWidth/CGRectGetWidth(self.bounds);
    CGFloat scaleY = (_cellWidth - 40)/(CGRectGetHeight(_fromView.bounds)/2);
    CATransform3D scaleTransform = CATransform3DMakeScale(scaleX, scaleY, 1);//缩小的3D变化
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/1000.0;
    CATransform3D rotateTransform = CATransform3DRotate(transform, -M_PI*179.999/180, 1, 0, 0);//翻转的3D变化
    
    
    CABasicAnimation *topCloseAnimation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
    topCloseAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    topCloseAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(scaleTransform, rotateTransform)];
    topCloseAnimation.removedOnCompletion = NO;
    topCloseAnimation.fillMode = kCAFillModeForwards;
    topCloseAnimation.duration = animationDuration;
    [topView.layer addAnimation:topCloseAnimation forKey:@"topCloseAnimation"];
    
    CABasicAnimation *bottomCloseAnimation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
    bottomCloseAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    bottomCloseAnimation.toValue = [NSValue valueWithCATransform3D:scaleTransform];
    bottomCloseAnimation.removedOnCompletion = NO;
    bottomCloseAnimation.fillMode = kCAFillModeForwards;
    bottomCloseAnimation.duration = animationDuration;
    [bottomView.layer addAnimation:bottomCloseAnimation forKey:@"bottomCloseAnimation"];
}

- (void)clickCell:(JHYearListCell *)cell {
    
    if(cell.tag != _currentIndex){
        return;
    }
    
    _currentCell = cell;
    cell.topImageView.hidden = YES;
    cell.bottomImageView.hidden = YES;
    
    CGRect bottomRect = [cell convertRect:cell.bottomImageView.frame toView:self];
    CGRect topRect = [cell convertRect:cell.topImageView.frame toView:self];
    
    JHDoubleFaceView *bottomView = [[JHDoubleFaceView alloc]initWithFrame:CGRectZero];
    bottomView.layer.anchorPoint = CGPointMake(0.5, 0);
    bottomView.frame = bottomRect;
    bottomView.frontView = _bottomFromView;
    [self addSubview:bottomView];
    
    JHDoubleFaceView *topView = [[JHDoubleFaceView alloc]initWithFrame:CGRectZero];
    topView.layer.anchorPoint = cell.topImageView.layer.anchorPoint;
    topView.frame = topRect;
    NSNumber *year1 = _rows[_currentIndex];
    topView.frontView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"year_select_image%@",year1]]];
    topView.backView = _topFromView;
    topView.backTransform = CATransform3DGetAffineTransform(CATransform3DMakeRotation(M_PI, 1, 0, 0));
    [self addSubview:topView];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect rect = topView.frame;
        rect.origin.y += 70;
        topView.frame = rect;
        
        rect = bottomView.frame;
        rect.origin.y += 70;
        bottomView.frame = rect;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [bottomView removeFromSuperview];
            [topView removeFromSuperview];
            [self removeFromSuperview];
            self.alpha = 1;
            if([_delegate respondsToSelector:@selector(yearListView:didSelected:)]){
                [_delegate yearListView:self didSelected:cell.yearLabel.text];
            }
        }];
    }];
    
    CGFloat scaleX = CGRectGetWidth(self.bounds)/_cellWidth;
    CGFloat scaleY = (CGRectGetHeight(_fromView.bounds)/2)/(_cellWidth - 40);
    CATransform3D scaleTransform = CATransform3DMakeScale(scaleX, scaleY, 1);//放大3D变化
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/1000.0;
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*179.999/180, 1, 0, 0);//翻转3D变化
    
    CABasicAnimation *topCloseAnimation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
    topCloseAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    topCloseAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(rotateTransform,scaleTransform)];
    topCloseAnimation.removedOnCompletion = NO;
    topCloseAnimation.fillMode = kCAFillModeForwards;
    topCloseAnimation.duration = animationDuration;
    [topView.layer addAnimation:topCloseAnimation forKey:@"topCloseAnimation"];
    
    CABasicAnimation *bottomCloseAnimation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
    bottomCloseAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    bottomCloseAnimation.toValue = [NSValue valueWithCATransform3D:scaleTransform];
    bottomCloseAnimation.removedOnCompletion = NO;
    bottomCloseAnimation.fillMode = kCAFillModeForwards;
    bottomCloseAnimation.duration = animationDuration;
    [bottomView.layer addAnimation:bottomCloseAnimation forKey:@"bottomCloseAnimation"];
}

@end
