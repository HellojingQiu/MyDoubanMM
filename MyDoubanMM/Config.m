//
//  Config.m
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "Config.h"

@implementation Config

static Config *_config;
+(instancetype)sharedConfig1{
    if (!_config) {
        _config=[[self allocWithZone:NULL]init];
    }
    return _config;
}

+(instancetype)sharedConfig{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config=[[self allocWithZone:NULL]init];
    });
    return _config;
}

-(void)setLayoutType:(LayoutType)type{
    [[NSUserDefaults standardUserDefaults]setInteger:type forKey:@"LayoutType"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(LayoutType)getLayoutType{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"LayoutType"];
}
@end
