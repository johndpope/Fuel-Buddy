//
//  FuelListView.h
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FuelStation;


@protocol StationsListDelegate <NSObject>
- (void)selectFuelStation:(FuelStation *)station;
@end


@interface FuelListView : UIView
@property (weak, nonatomic) id <StationsListDelegate> delegate;
- (void)setupStations:(NSArray *)stations;

@end
