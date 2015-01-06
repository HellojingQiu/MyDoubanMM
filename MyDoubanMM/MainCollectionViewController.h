//
//  MainCollectionViewController.h
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <hpple/TFHpple.h>
#import <MJRefresh/MJRefresh.h>
#import <KVNProgress/KVNProgress.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <iOS-Slide-Menu/SlideNavigationController.h>
#import <JTSImageViewController/JTSImageViewController.h>
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface MainCollectionViewController : UICollectionViewController<SlideNavigationControllerDelegate,JTSImageViewControllerInteractionsDelegate,CHTCollectionViewDelegateWaterfallLayout,UIActionSheetDelegate>

@property (copy,nonatomic)NSString *dataUrl;
@end
