//
//  SettingTableViewController.h
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDImageCache.h>
#import <KVNProgress/KVNProgress.h>
#import <AFNetworking/AFNetworking.h>
#import <iOS-Slide-Menu/SlideNavigationController.h>
@interface SettingTableViewController : UITableViewController<SlideNavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblImgStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblCacheSize;

@end
