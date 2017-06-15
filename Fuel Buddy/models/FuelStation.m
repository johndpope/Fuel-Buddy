//
//  FuelStation.m
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//


#import "FuelStation.h"
@import GoogleMaps;

#define ARC4RANDOM_MAX      0x100000000


@implementation FuelStation

//generate fuelStation
- (instancetype)initRandom {
    if (self = [super init]) {
        BOOL random = arc4random() % 100 % 2;
        _name = random ? @"Газпром" : @"Автозаправка Shell";
        _address = random ? @"ул, Карла-Маркса, 112" : @"ул, Первомайская, 112";
        _brandType = random;
        _price = random ? 35.5 : 39.8;
        _updateTime = random ? @"час назад" : @"4 часа назад";
        
        float randomLat = ((float)arc4random() - 0.5f) / ARC4RANDOM_MAX / 100.f;
        float randomLong = ((float)arc4random() - 0.5f) / ARC4RANDOM_MAX / 100.f;
        _coordinate = CLLocationCoordinate2DMake(55.745885 + randomLat, 37.602286 + randomLong);
        _distance = random ? 0.7f :0.9f;
        
        
        //setup marker
        _marker = [[GMSMarker alloc]init];
        _marker.position = _coordinate;
        _marker.title = _address;
        _marker.snippet = [NSString stringWithFormat:@"%.1f", _price];
        _marker.iconView = [self markerView];
        _marker.tracksInfoWindowChanges = YES;
    }
    return self;
}

- (UIImageView *)markerView {
    static UIImageView* marker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //set marker icon
        marker = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"marker"]];
        marker.bounds = CGRectMake(0, 0, 20, 20);
    });
    return marker;
}
@end
