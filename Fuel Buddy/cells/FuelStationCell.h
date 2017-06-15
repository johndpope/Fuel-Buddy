//
//  FuelStationCell.h
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FuelStation;

@interface FuelStationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameStation;
@property (weak, nonatomic) IBOutlet UILabel *addressStation;
@property (weak, nonatomic) IBOutlet UILabel *priceStation;
@property (weak, nonatomic) IBOutlet UILabel *timeStation;
@property (weak, nonatomic) IBOutlet UILabel *distanceStation;
@property (weak, nonatomic) IBOutlet UIImageView *logoStation;


- (void)setupWithStation:(FuelStation *)station;
@end
