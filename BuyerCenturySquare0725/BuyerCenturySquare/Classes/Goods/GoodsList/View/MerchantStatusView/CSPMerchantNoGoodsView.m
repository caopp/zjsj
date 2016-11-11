//
//  CSPMerchantNoGoodsView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantNoGoodsView.h"

@implementation CSPMerchantNoGoodsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    self.sorryLabel.text = NSLocalizedString(@"sorry", @"很抱歉!");
    
    self.noGoodsLabel.text = NSLocalizedString(@"noGoods", @"商家暂无上架在售商品");
    

}


@end
