//
//  ServerManager.h
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FuelStation;



typedef void (^FuelStationsGet)(NSArray <FuelStation *>* fuelStations, NSError *error);

@interface ServerManager : NSObject
+ (ServerManager*)sharedManager;
- (void)getFuelStation:(FuelStationsGet)completionBlock;
@end
