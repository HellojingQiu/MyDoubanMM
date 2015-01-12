//
//  SettingTableViewController.m
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Config.h"
#import "Const.h"
@interface SettingTableViewController (){
    Config *_config;
}
@property (copy,nonatomic) NSString *cachesPath;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置
    _config=[[Config alloc]init];
    
    //图片样式刷新
    [self refreshImageStyle:self.lblImgStyle];
    
    //缓存数据刷新
    self.cachesPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    if (_cachesPath) {
        [self refreshCacheSize:self.lblCacheSize];
    }
}

-(void)refreshCacheSize{
    [self refreshCacheSize:self.lblCacheSize];
}

-(void)refreshImageStyle:(UILabel *)lblImgStyle{
    lblImgStyle.text=_config.getLayoutTypeName;
}

-(void)refreshCacheSize:(UILabel *)lblCacheSize{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.cachesPath]) {
        //提交指定的块给调剂队列,同步会等block执行完才返回(阻塞线程),异步在执行后立刻返回
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSEnumerator *enumerator=[[fileManager subpathsAtPath:_cachesPath] objectEnumerator];
            NSString *fileName;
            unsigned long long fileSize=0;
            while (fileName=[enumerator nextObject]) {
                NSString *fileNameAbs=[self.cachesPath stringByAppendingPathComponent:fileName];
                fileSize+=[self fileSizeAtPath:fileNameAbs];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                lblCacheSize.text=[NSString stringWithFormat:@"%.2fM",fileSize/1024.0/1024.0];
            });
        });
    }else lblCacheSize.text=@"0.0M";
}
//--<SlideNavigationControllerDelegate>
-(BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}
//计算文件大小
-(unsigned long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *manager=[NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            [self performSegueWithIdentifier:@"toLayoutTypeView" sender:self];
            break;
        }
        case 1: {
            if (indexPath.row == 1) {
                [[[UIActionSheet alloc]initWithTitle:@"确认清除缓存图片?"
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:@"确认清除"
                                   otherButtonTitles:nil, nil] showInView:tableView];
            }
            break;
        }
    }
}
//视图切换前的判断
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewController *layoutTypeView=[segue destinationViewController];
    if ([segue.identifier isEqualToString:@"toLayoutTypeView"]) {
        [layoutTypeView setTitle:@"样式设置"];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self deleteCaches];
            break;
        case 1:
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
    }
}

-(void)deleteCaches{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *bundleCachePath=[self.cachesPath stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    if ([fileManager fileExistsAtPath:bundleCachePath]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [fileManager removeItemAtPath:bundleCachePath error:nil];
            [[SDImageCache sharedImageCache]clearDisk];
            [[SDImageCache sharedImageCache]clearMemory];
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress showSuccessWithStatus:DELETE_SUCCESS];
                [self refreshCacheSize:self.lblCacheSize];
            });
        });
    }else{
        [KVNProgress showWithStatus:CACHES_EMPTY];
        [self refreshCacheSize:self.lblCacheSize];
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
