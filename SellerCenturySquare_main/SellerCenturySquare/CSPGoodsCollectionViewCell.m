//
//  CSPGoodsCollectionViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPGoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommodityGroupListDTO.h"
#import "CSPUtils.h"

@implementation CSPGoodsCollectionViewCell


-(void)drawRect:(CGRect)rect{

    self.swearImageView.contentMode = UIViewContentModeScaleAspectFill; // 这是整个view会被图片填满，图片比例不变 ，这样图片显示就会大于view
    
    self.swearImageView.clipsToBounds = YES;
    

}
- (void)setCommodityInfo:(Commodity *)commodityInfo {

    _commodityInfo = commodityInfo;
    @try {

        if (commodityInfo.dayNum == 0) {
            
            self.dayNumLabel.text = [NSString stringWithFormat:@"%ld",(long)commodityInfo.withinDays];
            self.dayNumUnitLabel.text = @"天\n内";
            
            
            
        }else{
            self.dayNumUnitLabel.text = @"天\n前";
            self.dayNumLabel.text = [NSString stringWithFormat:@"%ld", commodityInfo.dayNum];
        }

        
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        
        NSString* priceValue = [CSPUtils isRoundNumber:commodityInfo.price] ? [NSString stringWithFormat:@"%ld", (long)commodityInfo.price] : [NSString stringWithFormat:@"%.02f", commodityInfo.price];
        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:priceValue attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:22]}];
        
        [priceString appendAttributedString:priceValueString];
        
        self.priceLabel.attributedText = priceString;
        
        self.swearTitleLabel.text = commodityInfo.goodsName;
        
        if ([commodityInfo.goodsType isEqualToString:@"0"]) {
            
            
            self.minAmountLabel.text = [NSString stringWithFormat:@"%ld件起批", (long)commodityInfo.batchNumLimit];
            
            NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc]init];
            inputDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate* sendDate = [inputDateFormatter dateFromString:commodityInfo.firstOnsaleTime];
            
            NSDateFormatter* outputDateFormatter = [[NSDateFormatter alloc]init];
            outputDateFormatter.dateFormat = @"M月d日更新";
            
            self.updateDateLabel.text = [outputDateFormatter stringFromDate:sendDate];
        
        
        }else{
            
            self.minAmountLabel.text = @"";
            self.updateDateLabel.text = @"";
           
            
        }
        
        
        [self.swearImageView sd_setImageWithURL:[NSURL URLWithString:commodityInfo.pictureUrl] placeholderImage:[UIImage imageNamed:@"middle_placeHolder"]];
        
        [self.contentView sendSubviewToBack:self.blurView];
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

@end