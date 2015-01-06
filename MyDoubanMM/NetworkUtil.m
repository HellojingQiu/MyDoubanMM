//
//  NetworkUtil.m
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NetworkUtil.h"
#import <hpple/TFHpple.h>

@implementation NetworkUtil

static NetworkUtil *_netWrokUtil;
/**
 *  单例下载,实现responseSerializer,相当于以前的manager-responseSerializer-getResponse的流程
 *
 *  @return 单例对象
 */
+(instancetype)sharedNetworkUtil{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netWrokUtil=[[self class] manager];
        _netWrokUtil.requestSerializer.timeoutInterval=NETWORK_TIMEOUT;
        _netWrokUtil.responseSerializer=[AFHTTPResponseSerializer serializer];
    });
    return _netWrokUtil;
}


-(void)getImgURL:(NSString *)imgUrl withPage:(int)page whenSuccess:(void (^)(NSString *, NSArray *))success whenFailure:(void (^)(NSString *, NSError *))failure{
    NSNumber *pageN=[NSNumber numberWithInteger:page];
    [_netWrokUtil GET:imgUrl parameters:@{@"pg":pageN} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arrayImgS=[[TFHpple hppleWithHTMLData:responseObject] searchWithXPathQuery:@"/html/body/div[2]/ul[2]/li[@*]/div/div/span/img"];
        if (arrayImgS.count) {
            success(DOWNLOAD_SUCCESS,arrayImgS);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(DOWNLOAD_ERROR,error);
    }];
}
@end
