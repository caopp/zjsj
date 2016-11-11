//
//  GetCategoryDTO.m
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "GetCategoryDTO.h"

@implementation GetCategoryDTO

- (void)setDictFrom:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"id"]]) {
                
                self.Id  = [dictInfo objectForKey:@"id"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryNo"]]) {
                
                self.categoryNo = [dictInfo objectForKey:@"categoryNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"categoryName"]]) {
                
                self.categoryName = [dictInfo objectForKey:@"categoryName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"level"]]) {
                
                self.level = [dictInfo objectForKey:@"level"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"structureName"]]) {
                
                self.structureName = [dictInfo objectForKey:@"structureName"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"structureNo"]]) {
                
                self.structureNo = [dictInfo objectForKey:@"structureNo"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sort"]]) {
                
                self.sort = [dictInfo objectForKey:@"sort"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"parentId"]]) {
                
                self.parentId = [dictInfo objectForKey:@"parentId"];
            }
            
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
