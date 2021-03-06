//
//  GetPayMerchantDownloadDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetPayMerchantDownloadDTO.h"

@implementation GetPayMerchantDownloadDTO

-(void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                
                self.level = [dictInfo objectForKey:@"level"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadNum"]]) {
                
                self.downloadNum = [dictInfo objectForKey:@"downloadNum"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"buyDownloadQty"]]) {
                
                self.buyDownloadQty = [dictInfo objectForKey:@"buyDownloadQty"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"buyDownloadPrice"]]) {
                
                self.buyDownloadPrice = [dictInfo objectForKey:@"buyDownloadPrice"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"authFlag"]]) {
                
                self.authFlag = [dictInfo objectForKey:@"authFlag"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodsNo"]]) {
                
                self.goodsNo = [dictInfo objectForKey:@"goodsNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"skuNo"]]) {
                
                self.skuNo = [dictInfo objectForKey:@"skuNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"downloadFlag"]]) {
                
                self.downloadFlag = [dictInfo objectForKey:@"downloadFlag"];
            }
            
            /**
             *  购买等级（无购买权限时该等级为最低有权限购买的等级）
             */
            if ([self checkLegitimacyForData:dictInfo[@"buyLevel"]]) {
                
                self.buyLevel = dictInfo[@"buyLevel"];
                
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
@end
