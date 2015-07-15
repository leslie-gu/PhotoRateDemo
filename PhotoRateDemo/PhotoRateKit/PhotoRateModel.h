//
//  PhotoRateModel.h
//  PhotoRate
//
//  Created by leslie on 15/4/13.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Nope_selected,
    Like_selected
}PhotoRateAtitudeType;

@interface PhotoRateModel : NSObject

@property (nonatomic,strong)NSData * imageData;
@property (nonatomic,copy)NSString * photoRateName;
@property (nonatomic,assign)PhotoRateAtitudeType  atitudeType;


@end
