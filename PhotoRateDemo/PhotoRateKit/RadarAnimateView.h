//
//  RadarAnimateView.h
//  Arwen
//
//  Created by 于宙 on 15/2/27.
//  Copyright (c) 2015年 Hobbits Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadarAnimateView : UIView
{
    CGFloat maxRadius;
    CGFloat minRadius;
    CGFloat currentRadius;
    CGFloat stepRadius;
    CGFloat lineWidth;
    double lastFrame;
    
    CADisplayLink *displayLink;
    NSTimer *displayTimer;
}

@property (nonatomic, assign) CGPoint radarCenter;

- (void)startAnimate;

- (void)stopAnimate;

@end
