//
//  PhotoRateListView.m
//  PhotoRate
//
//  Created by leslie on 15/4/22.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "PhotoRateListView.h"

@interface PhotoRateListView ()
@property (nonatomic,strong)NSMutableArray * listViewArr;

@end

@implementation PhotoRateListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.listViewArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

//设置 堆叠的视图
- (void)setUpContentView:(NSDictionary *)info
{
    for (MCSwipeImagePostion i = MCSwipePositionBottom; i<=MCSwipePositionHead; i++) {
        PhotoRateView * sview = [PhotoRateView viewWithInfo:info];
        sview.swipePosition = i;
        [self addSubview:sview];
        [_listViewArr addObject:sview];
        sview.delegate = self;
        [sview initObserverAndGesture];
        
        [sview initPosition];
    }
    _topPhotoRateView = [_listViewArr lastObject];
}

- (PhotoRateView *)photoRateViewWithInfo:(NSDictionary *)info
{
    [_listViewArr removeLastObject];
    [_listViewArr makeObjectsPerformSelector:@selector(changePositionType)];
    PhotoRateView *photoRateView = [PhotoRateView viewWithInfo:info];
    photoRateView.delegate = self;
    photoRateView.swipePosition = MCSwipePositionBottom;
    
    [self insertSubview:photoRateView atIndex:0];
    [self.listViewArr insertObject:photoRateView atIndex:0];
    
    [photoRateView initPosition];
    return [_listViewArr lastObject];
}

/**
 *  设置照片打分有效 显示区域
 *
 *  @return rect
 */
- (CGRect)getContentRect
{
    return self.bounds;
}

/**
 *  对所有  listView 做 系列的 堆叠动画
 *
 *  @param offset
 */
- (void)panAniWithAllListView:(CGFloat)offset
{
    [_listViewArr makeObjectsPerformSelector:@selector(animationWithPan:) withObject:@(offset)];
}

/**
 *  每个成员View 恢复到原始位置
 */
- (void)belowImageReturnToCenter
{
    [_listViewArr makeObjectsPerformSelector:@selector(subBelowImageReturnToCenter)];
}

- (void)photoRateView:(PhotoRateView *)view wasChosenWithDirection:(MCSwipeDirection)direction
{
    [self photoRateViewWithInfo:nil];
    _topPhotoRateView = [_listViewArr lastObject];
    [_topPhotoRateView initObserverAndGesture];
}

@end
