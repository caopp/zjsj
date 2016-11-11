//
//  PhotoAlbumViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/11.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "PhotoAlbumViewController.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"
#import "ELCConsole.h"
#import "SendView.h"
#import "CustomBarButtonItem.h"
#import "UIColor+UIColor.h"
#import "CustomViews.h"

@interface PhotoAlbumViewController ()<UITableViewDataSource,UITableViewDelegate,SendViewDelegate ,ELCAssetCellDelegate>
{

    SendView *sendView;
}
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, assign) int columns;

@end

@implementation PhotoAlbumViewController




- (id)init
{
    self = [super init];
    if (self) {
        
        self.columns = 4;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113) style:UITableViewStylePlain];
    
    sendView = [[[NSBundle mainBundle]loadNibNamed:@"SendView" owner:self options:nil]lastObject];
    sendView.delegate = self;
    
    sendView.backgroundColor = [UIColor colorWithHexValue:0xf0f0f0 alpha:1];
    
    sendView.frame = CGRectMake(0 ,self.view.frame.size.height - 49,self.view.frame.size.width, 49);
    [self.view addSubview:sendView];
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    
    
#pragma mark --取消按钮-----
    
//        进行按钮设置（这里设置的按钮，是发送选中的图片，也就是选中的资源进行设置的）
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didClickCancelAction)];
        
//        [doneButtonItem setTitle:@"取消"];
        //设置右边的按钮
        [self.navigationItem setRightBarButtonItem:doneButtonItem];
 
    
    
    
#pragma mark -------返回按钮----
    
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(didClickBackAction) target:self]];

    
    
    //在后台进行执行（后台进行处理的处理图片，也就是后台把图片准备好）
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    
    // Register for notifications when the photo library has changed
    //进行通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparePhotos) name:ALAssetsLibraryChangedNotification object:nil];

}

-(void)didClickBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



//设置取消（整个相册的页面全部取消）
-(void)didClickCancelAction
{
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"cacelPhotoPage" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    
}


#pragma mark ------预览和发送两个方法-------

//两个方法写反

//发送代理方法
-(void)didClickPreviewButtonAction
{
    
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    
    for (ELCAsset *elcAsset in self.elcAssets) {
        if ([elcAsset selected]) {
            [selectedAssetsImages addObject:elcAsset];
        }
    }
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }
    
    [self.parent selectedAssets:selectedAssetsImages];

}
//预览代理方法
-(void)didClickSendViewAction
{



}
//对图片进行个数判断
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.columns = 4;
    [self.navigationItem setTitle:self.titlePT];
    
//    //把照片从最新的开始
//    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
//        self.columns = 4;
//        
//        self.tableView.contentOffset = CGPointMake(0, self.columns * self.view.frame.size.width/4);
//        
//    }else{
//        
//        NSInteger numRows = ceil([self.elcAssets count] / (float)self.columns);
//        
//        self.tableView.contentOffset = CGPointMake(0, (numRows - 1) * self.view.frame.size.width/4);
//        
//        
//    }
//    

    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
   
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ELCConsole mainConsole] removeAllIndex];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}


//在后台进行执行（后台准备好处理好的图片进行处理）
- (void)preparePhotos
{
    @autoreleasepool {
        
        //移除所有原有的显示的资源。
        [self.elcAssets removeAllObjects];
        //采用异步代理的方法进行对图片处理（选中的图片）
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }
            
            //对选中的资源进行设置
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            
            [elcAsset setParent:self];
            
            BOOL isAssetFiltered = NO;
            if (self.assetPickerFilterDelegate &&
                [self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)])
            {
                
                isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:(ELCAsset*)elcAsset];
                
            }
            
            if (!isAssetFiltered) {
                [self.elcAssets addObject:elcAsset];
                
            }
            
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // scroll to bottom
            long section = self.tableView.numberOfSections -1;//[self numberOfSectionsInTableView:self.tableView] - 1;
            long row = [self.tableView numberOfRowsInSection:section] -1;//[self tableView:self.tableView numberOfRowsInSection:section] - 1;
            if (section >= 0 && row >= 0) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                     inSection:section];
                
                [self.tableView scrollToRowAtIndexPath:ip
                                      atScrollPosition:UITableViewScrollPositionBottom
                                              animated:NO];
            }
            
            
        });
    }
}

- (void)ELCAssetCellShowSelectNub:(NSString *)nub
{
    
//    sendView.numberLabel.text = nub;
    
    //!取传过来的nub值有问题，修改为遍历数组中选中的对象
    int selectNum = 0;
    for (ELCAsset *elcAsset in self.elcAssets) {
        if ([elcAsset selected]) {
            selectNum = selectNum + 1;
        }
    }
    
    sendView.numberLabel.text = [NSString stringWithFormat:@"%d",selectNum];
    
    
}
//这方法（一方面记录下来选中的个数，以及选中的图片，，再者就是传递到前面，进行展示）
- (void)doneAction:(id)sender
{
    NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    
    for (ELCAsset *elcAsset in self.elcAssets) {
        if ([elcAsset selected]) {
            [selectedAssetsImages addObject:elcAsset];
        }
    }
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }
    [self.parent selectedAssets:selectedAssetsImages];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset
{
    NSUInteger selectionCount = 0;
    for (ELCAsset *elcAsset in self.elcAssets) {
        if (elcAsset.selected) selectionCount++;
    }
    BOOL shouldSelect = YES;
    if ([self.parent respondsToSelector:@selector(shouldSelectAsset:previousCount:)]) {
        shouldSelect = [self.parent shouldSelectAsset:asset previousCount:selectionCount];
    }
    return shouldSelect;
}

- (void)assetSelected:(ELCAsset *)asset
{
    if (self.singleSelection) {
        
        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset
{
    if (self.immediateReturn){
        return NO;
    }
    return YES;
}

- (void)assetDeselected:(ELCAsset *)asset
{
    if (self.singleSelection) {
        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    
    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset.asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
    
    int numOfSelectedElements = [[ELCConsole mainConsole] numOfSelectedElements];
    if (asset.index < numOfSelectedElements - 1) {
        NSMutableArray *arrayOfCellsToReload = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (int i = 0; i < [self.elcAssets count]; i++) {
            ELCAsset *assetInArray = [self.elcAssets objectAtIndex:i];
            if (assetInArray.selected && (assetInArray.index > asset.index)) {
                assetInArray.index -= 1;
                
                int row = i / self.columns;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                BOOL indexExistsInArray = NO;
                for (NSIndexPath *indexInArray in arrayOfCellsToReload) {
                    if (indexInArray.row == indexPath.row) {
                        indexExistsInArray = YES;
                        break;
                    }
                }
                if (!indexExistsInArray) {
                    [arrayOfCellsToReload addObject:indexPath];
                }
            }
        }
        [self.tableView reloadRowsAtIndexPaths:arrayOfCellsToReload withRowAnimation:UITableViewRowAnimationNone];
    }
}







#pragma mark ----table代理方法---


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //进行个数统计
    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
        self.columns = 4;
    }
    NSInteger numRows = ceil([self.elcAssets count] / (float)self.columns);
    
    
    return numRows;
    
    
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.elcAssets count] - index);
    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[ELCAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        
    }
    
    //对选中的，进行标记
    [cell setAssets:[self assetsForIndexPath:indexPath]];
    
    return cell;
    
}

//每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width/4;
}

- (int)totalSelectedAssets
{
    int count = 0;
    
    for (ELCAsset *asset in self.elcAssets) {
        if (asset.selected) {
            count++;
        }
    }
    return count;
}
@end
