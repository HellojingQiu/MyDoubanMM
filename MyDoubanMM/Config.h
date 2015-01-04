//
//  Config.h
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LayoutType) {
    LayoutTypeInstagram,
    LayoutTypeClassic,
    LayoutTypeWaterFall,
};

@interface Config : NSObject

+(instancetype)sharedConfig;
-(void)setLayoutType:(LayoutType)type;
-(LayoutType)getLayoutType;
@end
