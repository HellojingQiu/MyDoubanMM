//
//  Config.h
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LayoutType) {
    LayoutTypeInstagram = 1,
    LayoutTypeClassic   = 1<<1,
    LayoutTypeWaterFall = 1<<2,
};

NSString *df_map(LayoutType type){
    switch (type) {
        case 1:
            return @"LayoutTypeInstagram"; break;
        case 2:
            return @"LayoutTypeClassic"; break;
        case 4:
            return @"LayoutTypeWaterFall"; break;
    }
}

@interface Config : NSObject

+(instancetype)sharedConfig;
-(void)setLayoutType:(LayoutType)type;
-(LayoutType)getLayoutType;
@end
