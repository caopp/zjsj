//
//  CenterSampleShopMessageCellTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderParentTableViewCell.h"

@interface CenterSampleShopMessageCombinedTableViewCell : MyOrderParentTableViewCell
@property (weak, nonatomic) IBOutlet UIView *topViewCell;
@property (weak, nonatomic) IBOutlet UIView *bottomViewCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (nonatomic ,strong) MemberListDTO *recordMemberDto;
@property (nonatomic ,strong) OrderListDTO *recordListDto;


@end
