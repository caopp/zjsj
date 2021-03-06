//
//  CSPPesronCenterTopTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPesronCenterTopTableViewCell.h"

@implementation CSPPesronCenterTopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toPayButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(toPayClicked)]) {
        [self.delegate toPayClicked];
    }
}

- (IBAction)toDeliverButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toDeliverClicked)]) {
        [self.delegate toDeliverClicked];
    }
}

- (IBAction)toReciveButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toReciveClicked)]) {
        [self.delegate toReciveClicked];
    }
}

- (IBAction)allButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(allClicked)]) {
        [self.delegate allClicked];
    }
}
@end
