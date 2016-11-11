//
//  BadgeButton.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"


@interface BadgeButton : UIButton
{
    
    NSString *badgeNumber_;
    CustomBadge *badge_;
    
}

@property (nonatomic, strong) NSString *badgeNumber;

@property (nonatomic,strong)CustomBadge *badge;

@end
