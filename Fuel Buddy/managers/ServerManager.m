//
//  ServerManager.m
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "ServerManager.h"
#import "FuelStation.h"

@implementation ServerManager

+(ServerManager*)sharedManager {
    static ServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    return  manager;
}

#pragma mark - API methods

- (void)getFuelStation:(FuelStationsGet)completionBlock {
    NSMutableArray <FuelStation *> *stations = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < 30; ++i) {
        FuelStation *station = [[FuelStation alloc] initRandom];
        [stations addObject:station];
    }
    completionBlock(stations, nil);
}

@end
