//
//  PhotoRateView.h
//  PhotoRate
//
//  Created by leslie on 15/4/22.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AutoLayout.h"
IB_DESIGNABLE
typedef NS_ENUM(NSInteger, MCSwipeDirection) {
    MCSwipeDirectionNone = 0,
    MCSwipeDirectionLeft,
    MCSwipeDirectionRight
};


typedef NS_ENUM(NSInteger, MCSwipeImagePostion) {
    MCSwipePositionBottom = 0,
    MCSwipePositionMiddel = 1,
    MCSwipePositionTop = 2,
    MCSwipePositionHead = 3,
};

typedef NS_ENUM(NSInteger, MCSwipeChooseType){
    MCBtnClickChoose,
    MCPanGoingChoose,
};

@class PhotoRateView;

@protocol PhotoRateViewDelegate <NSObject>
@required
- (void)photoRateView:(PhotoRateView *)view wasChosenWithDirection:(MCSwipeDirection)direction;
- (void)panAniWithAllListView:(CGFloat)offset;
- (void)belowImageReturnToCenter;
- (CGRect)getContentRect;

@end

@interface PhotoRateView : UIView <UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIButton *likeView;
    __weak IBOutlet UIButton *nopeView;
}

@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, assign) MCSwipeDirection swipeDirection;
@property (nonatomic, assign) MCSwipeImagePostion swipePosition;
@property (nonatomic, weak)  id<PhotoRateViewDelegate> delegate;
@property (nonatomic, strong) NSDictionary* userInfo;


+ (instancetype)viewWithInfo:(NSDictionary *)info;

- (void)initPosition;
- (void)initObserverAndGesture;

- (void)mc_swipe:(MCSwipeDirection)direction;
- (void)animationWithPan:(NSNumber *)offset;
- (void)animationWithPanDid;
- (void)subBelowImageReturnToCenter;
- (void)changePositionType;
@end
