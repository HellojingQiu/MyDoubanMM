//
//  SideBarViewController.m
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SideBarViewController.h"
#import "MainCollectionViewController.h"
#import "Const.h"

@interface SideBarViewController ()

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //默认选中
    NSIndexPath *selectedPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    switch (indexPath.section) {
        case 0: {
            //取MainCollectionView
            UICollectionViewController *collectionView = [storyboard instantiateViewControllerWithIdentifier:@"MainCollectionView"];
            switch (indexPath.row) {
                case 0:
                    [collectionView setTitle:@"所有妹子"];
                    [collectionView setValue:MM_ALL forKey:@"dataUrl"];
                    break;
                case 1:
                    [collectionView setTitle:@"性感"];
                    [collectionView setValue:MM_SEX forKey:@"dataUrl"];
                    break;
                    //                case 2:
                    //                    [collectionView setTitle:@"有沟"];
                    //                    [collectionView setValue:MEIZI_CLEAVAGE forKey:@"datasource"];
                    //                    break;
                    //                case 3:
                    //                    [collectionView setTitle:@"美腿"];
                    //                    [collectionView setValue:MEIZI_LEGS forKey:@"datasource"];
                    //                    break;
                case 2:
                    [collectionView setTitle:@"小清新"];
                    [collectionView setValue:MM_FRESH forKey:@"dataUrl"];
                    break;
                case 3:
                    [collectionView setTitle:@"文艺"];
                    [collectionView setValue:MM_LITERATURE forKey:@"dataUrl"];
                    break;
                case 4:
                    [collectionView setTitle:@"其他"];
                    [collectionView setValue:MM_ALL forKey:@"dataUrl"];
                    break;
            }
            //跳转MainCollectionView
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:collectionView
                                                                     withSlideOutAnimation:NO
                                                                             andCompletion:nil];
            break;
        }
        case 1: {
            //取SettingTableView
            UITableViewController *settingTableView = [storyboard instantiateViewControllerWithIdentifier:@"SettingTableView"];
            //跳转SettingTableView
            [settingTableView setTitle:@"设置"];
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:settingTableView
                                                                     withSlideOutAnimation:NO
                                                                             andCompletion:nil];
            break;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
