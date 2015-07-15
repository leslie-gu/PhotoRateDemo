//
//  RadarAnimateView.m
//  Arwen
//
//  Created by 于宙 on 15/2/27.
//  Copyright (c) 2015年 Hobbits Co.,Ltd. All rights reserved.
//

#import "RadarAnimateView.h"

@implementation RadarAnimateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        minRadius = 2;
        maxRadius = 500;
        currentRadius = minRadius;
        stepRadius = 150;
        lineWidth = 2.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextClearRect(context, rect);
    
    CGContextSetLineWidth(context, lineWidth);
    
    CGFloat radius = currentRadius;
    while (radius < maxRadius) {
        [self drawCircleAtRadius:radius context:context];
        radius += stepRadius;
    }
}

- (void)drawCircleAtRadius:(CGFloat)radius context:(CGContextRef)context
{
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 1.0 - radius / 400);
//    CGContextSetRGBFillColor(context, 0.8, 0.3, 0.3, 1.0 - radius / 400);

    CGRect circleRect = CGRectMake(self.radarCenter.x - radius, self.radarCenter.y - radius, radius * 2, radius * 2);

    CGContextStrokeEllipseInRect(context, circleRect);
//    CGContextFillEllipseInRect(context, circleRect);
}

- (void)startAnimate
{
    if (displayTimer == nil) {
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:1 / 60 target:self selector:@selector(updateAnimate:) userInfo:nil repeats:YES];
    }
    
    return;
    if (displayLink == nil) {
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAnimate:)];
//        displayLink.frameInterval = 2;
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    if (displayLink.paused) {
        displayLink.paused = NO;
    }
}

- (void)stopAnimate
{
    [displayTimer invalidate];
    
    return;
    displayLink.paused = YES;
}

- (void)updateAnimate:(CADisplayLink *)_displayLink
{
    if (currentRadius >= stepRadius + minRadius) {
        currentRadius = minRadius;
    }

//    CGFloat interval = 0;
//    if (lastFrame == 0) {
//        interval = _displayLink.duration;
//        lastFrame = _displayLink.timestamp;
//    }
//    else {
//        interval = _displayLink.timestamp - lastFrame;
//        lastFrame = _displayLink.timestamp;
//    }
    
    currentRadius += 1;//interval * 60;
//    FLOG(@"%0.3f", currentRadius);
    
    [self setNeedsDisplay];
}

- (void)didMoveToSuperview
{
    if (self.superview == nil) {
        [displayLink invalidate];
    }
}

@end
