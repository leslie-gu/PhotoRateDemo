//
//  PhotoRateListView.h
//  PhotoRate
//
//  Created by leslie on 15/4/22.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoRateView.h"

@interface PhotoRateListView : UIView <PhotoRateViewDelegate>

@property(nonatomic, strong) PhotoRateView *topPhotoRateView;

- (void)setUpContentView:(NSDictionary *)info;
@end