//
//  FuelStationCell.m
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "FuelStationCell.h"
#import "FuelStation.h"

@implementation FuelStationCell

#pragma mark - InterfaceAPI

- (void)setupWithStation:(FuelStation *)station {
    self.nameStation.text = station.name;
    self.addressStation.text = station.address;
    self.priceStation.text = [NSString stringWithFormat:@"%.1f",station.price];
    self.timeStation.text = station.updateTime;
    self.distanceStation.text = [NSString stringWithFormat:@"%.2f км",station.distance];
    
    //setup logo image
    //self.logoStation.text = station.name; @property (assign, nonatomic, readonly) BrandType brandType;
}


#pragma mark - Main ovveriden methods

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
