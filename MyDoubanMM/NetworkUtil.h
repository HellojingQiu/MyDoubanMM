//
//  NetworkUtil.h
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "Const.h"

@interface NetworkUtil : AFHTTPSessionManager

+(instancetype)sharedNetworkUtil;

-(void)getImgURL:(NSString *)imgUrl withPage:(int)page whenSuccess:(void(^)(NSString *successMsg,NSArray *arrayImgS))success whenFailure:(void (^)(NSString *failureMsg,NSError *error))failure;
@end
