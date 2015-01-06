//
//  ImageCell.h
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (copy,nonatomic) NSString *iconUrl;
@property (copy,nonatomic) NSString *bigUrl;
@property (copy,nonatomic) NSString *content;
@end
