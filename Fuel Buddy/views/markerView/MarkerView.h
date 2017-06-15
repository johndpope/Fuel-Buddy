//
//  InfoWindow.h
//  PrivatBank
//
//  Created by admin on 06.12.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *fuelStationIcon;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *navigationButton;

@end
