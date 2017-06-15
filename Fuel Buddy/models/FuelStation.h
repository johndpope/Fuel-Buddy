//
//  FuelStation.h
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef enum : NSUInteger {
    Gazprom,
    Shell
} BrandType;

@class GMSMarker;


@interface FuelStation : NSObject <NSCopying>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *address;
@property (assign, nonatomic, readonly) BrandType brandType;
@property (strong, nonatomic, readonly) NSString *updateTime;
@property (assign, nonatomic, readonly) float price;
@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic, readonly) float distance;

@property (strong, nonatomic, readonly) GMSMarker *marker;

- (instancetype)initRandom;
@end
