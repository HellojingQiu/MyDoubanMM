//
//  MainCollectionViewController.m
//  MyDoubanMM
//
//  Created by qianfeng on 15/1/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "Config.h"
#import "Const.h"
#import "NetworkUtil.h"
#import "ImageCell.h"
@interface MainCollectionViewController ()

@property (assign,nonatomic) int page;
@property (assign,nonatomic) LayoutType layoutType;
@property (retain,nonatomic) UIImage *selectedImage;
@property (strong,nonatomic) NSMutableArray *arrayImg;
@property (strong,nonatomic) NSMutableArray *arrayImgSize;
//Strong相当于retain
//weak相当于asisign,顺便弃置时nil
@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"ImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _layoutType=[[Config sharedConfig]getLayoutType];
    self.dataUrl=self.dataUrl?self.dataUrl:MM_ALL;
    self.arrayImg=[NSMutableArray array];
    self.arrayImgSize=[NSMutableArray array];
    
    [self setCollectionLayout:_layoutType];
    
    __weak typeof(self) weakSelf=self;//创建一个弱引用指针,以防止self的循环引用而走不到dealloc,主要用于代码块中
    
    //Header
    [self.collectionView addHeaderWithCallback:^{
        if (!weakSelf.arrayImg.count) {
            [weakSelf createDataWithpage:1 AndCompletion:^(int count, NSString *message) {
                [weakSelf appendCellsize:count];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView headerEndRefreshing];
            }];
        }else{
            [weakSelf.collectionView headerEndRefreshing];//如果有数据就不再刷新
        }
    } dateKey:nil];
    //Footer
    [self.collectionView addFooterWithCallback:^{
        [weakSelf createDataWithpage:weakSelf.page AndCompletion:^(int count, NSString *message) {
            [weakSelf appendCellsize:count];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView footerEndRefreshing];
        }];
    }];
    //加载后的第一次刷新
    [weakSelf.collectionView headerBeginRefreshing];
    
    // Do any additional setup after loading the view.
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self setLayoutType:[[Config sharedConfig]getLayoutType]];
//    [self.collectionView reloadData];
//}
/**
 *  根据图片数量,添加随机大小的图片边框
 *
 *  @param count 图片数量
 */
-(void)appendCellsize:(int)count{
    for (int i=0; i<count; i++) {
        //随机图片边框大小,但不小于50
        CGSize cellSize=CGSizeMake(arc4random()%50+50, arc4random()%50+50);
        [self.arrayImgSize addObject:[NSValue valueWithCGSize:cellSize]];
    }
}

/**
 *  下载图片
 *
 *  @param page       第几页
 *  @param completion 代码块,count:一页的数量  message:
 */
-(void)createDataWithpage:(int)page AndCompletion:(void(^)(int count,NSString *message))completion{
    [[NetworkUtil sharedNetworkUtil] getImgURL:_dataUrl withPage:page whenSuccess:^(NSString *successMsg, NSArray *arrayImgS) {
        self.page++;
        [self.arrayImg addObjectsFromArray:arrayImgS];
        completion(arrayImgS.count,successMsg);
    } whenFailure:^(NSString *failureMsg, NSError *error) {
        [KVNProgress showErrorWithStatus:failureMsg];
        completion(0,failureMsg);
    }];
}

-(void)setCollectionLayout:(LayoutType)layoutType{
    switch (layoutType) {
        case LayoutTypeInstagram:
            break;
        case LayoutTypeClassic:
            break;
        case LayoutTypeWaterFall:{
            CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
            layout.columnCount=2;
            layout.minimumColumnSpacing=1;
            layout.minimumInteritemSpacing=1;
            layout.sectionInset=UIEdgeInsetsMake(1, 1, 1, 1);
            [self.collectionView setCollectionViewLayout:layout];
            
            break;
        }
    }
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.layoutType) {
        case 0:
            return CGSizeMake(CGRectGetWidth(self.view.bounds)/3-1, CGRectGetWidth(self.view.bounds)/3-1);
            break;
        case 1:
            return CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
            break;
        case 2:
            return [self.arrayImgSize[indexPath.item]CGSizeValue];
            break;
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionViewz{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrayImg.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取选中的Cell
    ImageCell *cell = (ImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //创建图片信息
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc]init];
    imageInfo.imageURL = [NSURL URLWithString:cell.bigUrl];
    imageInfo.altText = cell.content;
    imageInfo.referenceRect = cell.frame;
    imageInfo.referenceView = cell.superview;
    //图片浏览Viewer
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    imageViewer.interactionsDelegate = self;
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (BOOL)imageViewerAllowCopyToPasteboard:(JTSImageViewController *)imageViewer {
    return YES;
}

- (BOOL)imageViewerShouldTemporarilyIgnoreTouches:(JTSImageViewController *)imageViewer {
    return NO;
}

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect {
    self.selectedImage = imageViewer.image;
    [[[UIActionSheet alloc]initWithTitle:nil
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:@"保存到手机"
                       otherButtonTitles:nil, nil]showInView:self.view];
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            [KVNProgress showWithStatus:@"正在保存..."];
            UIImageWriteToSavedPhotosAlbum(self.selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            break;
        }
        case 1: {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark SavePhotoToPhone
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error) {
        [KVNProgress showErrorWithStatus:@"保存图片失败"];
    }else{
        [KVNProgress showSuccessWithStatus:@"保存图片成功"];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.indicator setHidesWhenStopped:YES];
    [cell.indicator startAnimating];
    
    NSDictionary *dicMM=[(TFHppleElement *)[self.arrayImg objectAtIndex:indexPath.row] attributes];
    
    cell.iconUrl=dicMM[@"data-src"];
    cell.bigUrl=dicMM[@"data-bigimg"];
    cell.content=dicMM[@"alt"];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cell.iconUrl] placeholderImage:[UIImage imageNamed:@"chongwu15.jpg"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image&&!error) {
            [cell.indicator stopAnimating];
            [cell.imageView setImage:image];
        }else{
            [cell.indicator stopAnimating];
            [cell.imageView setImage:[UIImage imageNamed:@"PlaceHolder"]];
        }
    }];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
