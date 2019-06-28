//
//  ForecastDataPoint+ForecastDataPoint_Extension.h
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/28/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "ForecastDataPoint+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WeatherType) {
    WeatherTypeUnknown,
    WeatherTypeSunny,
    WeatherTypeCloudy,
    WeatherTypeRain,
    WeatherTypeSnow,
    WeatherTypeWind
};


@interface ForecastDataPoint (Extension)

- (WeatherType)weatherType;

@end

NS_ASSUME_NONNULL_END
