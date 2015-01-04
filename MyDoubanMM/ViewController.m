//
//  ViewController.m
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "WWSideslipViewController.h"
#import "SlipViewController/LeftViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"sd");
    LeftViewController *VCLeft=[[LeftViewController alloc]init];
    WWSideslipViewController *slide=[[WWSideslipViewController alloc]initWithLeftView:VCLeft andMainView:self andRightView:VCLeft andBackgroundImage:nil];
    
    slide.sideslipTapGes.enabled=YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
