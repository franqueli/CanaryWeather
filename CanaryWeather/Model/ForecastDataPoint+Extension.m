//
//  ForecastDataPoint+ForecastDataPoint_Extension.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/28/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "ForecastDataPoint+Extension.h"

@implementation ForecastDataPoint (Extension)

- (WeatherType)weatherType {
    WeatherType weatherType = WeatherTypeUnknown;
    
    if ([self.icon isEqualToString:@"clear-day"]) {
        weatherType = WeatherTypeSunny;
    } else if ([self.icon isEqualToString:@"clear-night"]) {
        weatherType = WeatherTypeSunny;
    } else if ([self.icon isEqualToString:@"rain"]) {
        weatherType = WeatherTypeRain;
    } else if ([self.icon isEqualToString:@"snow"]) {
        weatherType = WeatherTypeSnow;
    } else if ([self.icon isEqualToString:@"sleet"]) {
        weatherType = WeatherTypeSnow;
    } else if ([self.icon isEqualToString:@"wind"]) {
        weatherType = WeatherTypeWind;
    } else if ([self.icon isEqualToString:@"fog"]) {
        weatherType = WeatherTypeCloudy;
    } else if ([self.icon isEqualToString:@"cloudy"]) {
        weatherType = WeatherTypeCloudy;
    } else if ([self.icon isEqualToString:@"partly-cloudy-day"]) {
        weatherType = WeatherTypeCloudy;
    } else if ([self.icon isEqualToString:@"partly-cloudy-night"]) {
        weatherType = WeatherTypeCloudy;
    }
    
    return weatherType;
}


@end
