//
// Created by Franqueli Mendez on 2019-07-01.
// Copyright (c) 2019 Franqueli Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForecastDataPoint+Extension.h"

@class UIImage;


@interface ForecastViewModel : NSObject

+ (UIImage *) imageForWeatherType: (WeatherType) weatherType;
+ (NSString *) captionForWeatherType: (WeatherType) weatherType;

@end