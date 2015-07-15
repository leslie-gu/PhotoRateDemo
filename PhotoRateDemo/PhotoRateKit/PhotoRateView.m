//
//  PhotoRateView.m
//  PhotoRate
//
//  Created by leslie on 15/4/22.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "PhotoRateView.h"

#import "UIView+Addition.h"

@interface PhotoRateView ()
{
    UIPanGestureRecognizer *recongnizer;
    
    CGPoint beginPoint,mbeginPoint,originalCenter;
}
@property (nonatomic,assign)BOOL  isChooseDone;
@property (nonatomic,assign)MCSwipeChooseType  chooseType;

@end

@implementation PhotoRateView

+ (instancetype)viewWithInfo:(NSDictionary *)info
{
    PhotoRateView *view = [[[NSBundle mainBundle] loadNibNamed:@"PhotoRateView" owner:self options:nil] firstObject];
    view.userInfo = info;
    
    return view;
}

- (void)awakeFromNib
{
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = true;
    self.translatesAutoresizingMaskIntoConstraints = YES;
}


- (void)initObserverAndGesture
{
    //Pan手势
    recongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    [self addGestureRecognizer:recongnizer];
    [recongnizer setDelegate:self];
    recongnizer.maximumNumberOfTouches = 1;
    [self setMultipleTouchEnabled:YES];
    [recongnizer setDelaysTouchesBegan:YES];
    [recongnizer setDelaysTouchesEnded:YES];
}

- (void)initPosition
{
    likeView.alpha = 0.f;
    nopeView.alpha = 0.f;
    [self resetPostion];
}

/**
 *  获取视图的  位置   position  原始偏移量
 *
 *  @param position
 *
 *  @return
 */
- (CGFloat)getOffsetForPostion:(MCSwipeImagePostion)position
{
    switch (position) {
        case MCSwipePositionBottom:
        {
            return 80;
        }
            break;
        case MCSwipePositionMiddel:
        {
            return 80;
        }
            break;
        case MCSwipePositionTop:
        {
            return 55;
        }
            break;
        case MCSwipePositionHead:
        {
            return 0;
        }
            break;
            
        default:
            break;
    }
}

/**
 *  获取视图的  scale
 *
 *  @param position
 *
 *  @return
 */
- (CGFloat)getScaleChangeForPostion:(MCSwipeImagePostion)position
{
    switch (position) {
        case MCSwipePositionBottom:
        {
            return 0.85;
        }
            break;
        case MCSwipePositionMiddel:
        {
            return 0.85;
        }
            break;
        case MCSwipePositionTop:
        {
            return 0.9;
        }
            break;
        case MCSwipePositionHead:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
}

/**
 *  各个层叠View 的初始位置放置逻辑
 */
- (void)resetPostion
{
    self.transform = CGAffineTransformIdentity;
    CGFloat yy = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    CGRect contentRect = [_delegate getContentRect];
    width = contentRect.size.width/1.2;
    height = width*1.3;
    
    yy = (contentRect.size.height - height)/4 + [self getOffsetForPostion:self.swipePosition];
    
    self.top = yy;
    self.width = width;
    self.width = width * [self getScaleChangeForPostion:self.swipePosition];
    self.height = height * [self getScaleChangeForPostion:self.swipePosition];
    self.left = self.superview.width/2- self.width/2;
    self.threshold = self.width/2.0;
}

/**
 *  点击后的 一处动画逻辑
 *
 *  @param direction
 */
- (void)mc_swipe:(MCSwipeDirection)direction
{
    self.chooseType = MCBtnClickChoose;
    __block float  shakeWidth = 0;
    __block UIView *animateView = nil;
    if (direction == MCSwipeDirectionLeft) {
        animateView = nopeView;
        shakeWidth  = 5;
    }
    else if (direction == MCSwipeDirectionRight) {
        animateView = likeView;
        shakeWidth  = -5;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoRateView:wasChosenWithDirection:)]) {
        [self.delegate photoRateView:self wasChosenWithDirection:direction];
    }
    
    //向反方向移动5像素
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        animateView.alpha = 0.5;
        self.left -= shakeWidth;
        
    } completion:^(BOOL finished) {
        
        //移出屏幕
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            if (direction == MCSwipeDirectionLeft) {
                self.left -= self.width*1.5;
                self.top -= 100;
            }else{
                self.left += self.width;
                self.top -= 100;
            }
            
            //角度倾斜处理
            CGFloat rotationStrength = MIN(self.left / 320, 1);
            CGFloat rotationAngel = (CGFloat) (2*M_PI/39 * rotationStrength);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            self.transform = transform;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

/**
 *  判断滑动的速度和方向  当手势滑动速度  大于 300 的时候才会判断为滑动选中
 *
 *  @param recognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)recognizer
{
    CGFloat  speed = 0.0;
    CGFloat  x_speed = 0.0;
    CGFloat  y_speed = 0.0;
    CGPoint  point = [recognizer velocityInView:self.superview];
    x_speed = point.x;
    y_speed = point.y;
    
    speed = sqrt(x_speed*x_speed+y_speed*y_speed);
    
    if (x_speed>0&&y_speed<0) {
        NSLog(@"右上");
        self.swipeDirection = MCSwipeDirectionRight;
    }else if(x_speed>0&&y_speed>0){
        NSLog(@"右下");
        self.swipeDirection = MCSwipeDirectionRight;
    }else if(x_speed<0&&y_speed<0){
        NSLog(@"左上");
        self.swipeDirection = MCSwipeDirectionLeft;
    }else if(x_speed<0&&y_speed>0){
        NSLog(@"左下");
        self.swipeDirection = MCSwipeDirectionLeft;
    }else{
        NSLog(@"没动");
        self.swipeDirection = MCSwipeDirectionNone;
    }
    
    if (speed >=300) {
        _isChooseDone = YES;
    }else{
        _isChooseDone = NO;
    }
    //    NSLog(@"panSpeed*************:%f",speed);
}

/**
 *
 *  拖动逻辑
 *  @param recognizer
 */

- (void)panRecognizer:(UIPanGestureRecognizer *)recognizer
{
    
    [self panDirection:recognizer];
    
    CGPoint draggingPoint = [recognizer locationInView:self.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //添加遮罩
        beginPoint = draggingPoint;
        mbeginPoint = [recognizer locationInView:self];
    }
    
    //手势移动
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat positionX =  draggingPoint.x - mbeginPoint.x + self.width/2;
        
        CGFloat positionY =  draggingPoint.y - mbeginPoint.y + self.height/2;
        
        CGPoint  positionPoint = CGPointMake(positionX, positionY);
        
        self.center = positionPoint;
        
        CGFloat xDistance = [recognizer translationInView:self.superview].x;
        CGFloat yDistance = [recognizer translationInView:self.superview].y;
        
        CGFloat distanceOffset = MAX(fabs(xDistance), fabs(yDistance));
        
        [_delegate panAniWithAllListView:distanceOffset];
        
        //角度倾斜处理
        CGFloat rotationStrength = MIN(xDistance / self.width, 1);
        CGFloat rotationAngel = (CGFloat) (2*M_PI/39 * rotationStrength);
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
        self.transform = transform;
        
        //透明度的处理
        CGFloat thresholdRatio = MIN(1.f, fabsf((float)xDistance)/(self.width/2));
        
        if (self.swipeDirection == MCSwipeDirectionNone) {
            
        } else if (self.swipeDirection == MCSwipeDirectionLeft) {
            likeView.alpha = 0.f;
            nopeView.alpha = thresholdRatio;
        } else if (self.swipeDirection == MCSwipeDirectionRight) {
            likeView.alpha = thresholdRatio;
            nopeView.alpha = 0.f;
        }
    }
    
    //手势结束的处理
    if (recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self returnToOriginalCenter];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (_isChooseDone) {
            if (self.swipeDirection == MCSwipeDirectionLeft) {
                [self wasChosenWithDirection:MCSwipeDirectionLeft];
            }
            else if (self.swipeDirection == MCSwipeDirectionRight ){
                [self wasChosenWithDirection:MCSwipeDirectionRight];
            }else{
                [self returnToOriginalCenter];
            }
        }else{
            [self returnToOriginalCenter];
        }
    }
}

/**
 *  拖动过程中的  视图一系列变换
 *
 *  @param offset
 */
- (void)animationWithPan:(NSNumber *)offset
{
    CGFloat offsetValue = MIN([offset floatValue] /self.threshold, 1);
    self.chooseType = MCPanGoingChoose;
    
    if (self.swipePosition != MCSwipePositionHead&&self.swipePosition != MCSwipePositionBottom) {
        CGFloat width = 0;
        CGFloat height = 0;
        CGRect contentRect = [_delegate getContentRect];
        width = contentRect.size.width/1.2;
        height = width*1.3;
        
        CGFloat  diffrenceOffset = [self getOffsetForPostion:self.swipePosition + 1] - [self getOffsetForPostion:self.swipePosition];
        
        CGFloat yy = (contentRect.size.height - height)/4 + [self getOffsetForPostion:self.swipePosition] + diffrenceOffset * offsetValue;
        
        self.top = yy;
        
        self.width = width * [self getScaleChangeForPostion:self.swipePosition] + ([self getScaleChangeForPostion:self.swipePosition + 1] - [self getScaleChangeForPostion:self.swipePosition])*offsetValue*width;
        
        
        self.height = height * [self getScaleChangeForPostion:self.swipePosition] + ([self getScaleChangeForPostion:self.swipePosition + 1] - [self getScaleChangeForPostion:self.swipePosition])*offsetValue*height;
        
        self.left = self.superview.width/2- self.width/2;
    }
}

/**
 *
 *  拖动结束后的 所有视图的动作
 *  @return
 */
- (void)animationWithPanDid
{
    if (self.chooseType == MCPanGoingChoose) {
        [self resetPostion];
    }else{
        [UIView animateWithDuration:0.3 animations:^(void){
            [self resetPostion];
        }];
    }
}

/**
 *  有选中的  View 被移除后  的 逻辑和 swipePosition 标记变换
 */
- (void)changePositionType
{
    if (self.swipePosition < MCSwipePositionHead) {
        self.swipePosition += 1;
    }
    [self animationWithPanDid];
}

/**
 *  移动到 指定位置后  开始选中逻辑
 *
 *  @param direction
 */
- (void)wasChosenWithDirection:(MCSwipeDirection)direction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoRateView:wasChosenWithDirection:)]) {
        [self.delegate photoRateView:self wasChosenWithDirection:direction];
    }
    
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        
        if (direction == MCSwipeDirectionLeft) {
            self.left -= self.width*1.5;
            self.top -= 100;
        }else{
            self.left += self.width*1.5;
            self.top  -= 100;
        }
        
        //角度倾斜处理
        CGFloat rotationStrength = MIN(self.left / 320, 1);
        CGFloat rotationAngel = (CGFloat) (2*M_PI/39 * rotationStrength);
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
        self.transform = transform;
        
        
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 *  每个成员View 恢复到原始位置
 */
- (void)subBelowImageReturnToCenter
{
    [self resetPostion];
}

/**
 *  还原到起始位置的动画
 */
- (void)returnToOriginalCenter
{
    likeView.alpha = 0.f;
    nopeView.alpha = 0.f;
    self.swipeDirection = MCSwipeDirectionNone;
    
    //弹簧效果
    [[self class] springAnimateWithDuration:0.5 animations:^{
        [_delegate belowImageReturnToCenter];
    } completion:nil];
}

/**
 *  弹簧效果
 *
 *  @param duration
 *  @param animations
 *  @param completion
 */
+ (void)springAnimateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    if ([[UIView class] respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0
                            options:UIViewAnimationOptionTransitionCurlDown animations:animations completion:completion];
    }else{
        [UIView animateWithDuration:duration  animations:animations completion:completion];
    }
}

@end
