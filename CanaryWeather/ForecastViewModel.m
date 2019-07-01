//
// Created by Franqueli Mendez on 2019-07-01.
// Copyright (c) 2019 Franqueli Mendez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForecastViewModel.h"


@implementation ForecastViewModel {

}

+ (UIImage *) imageForWeatherType: (WeatherType)weatherType {
    NSString *iconImageName = nil;

    switch (weatherType) {
        case WeatherTypeUnknown:
            iconImageName = @"Rainbow";
            break;
        case WeatherTypeSunny:
            iconImageName = @"Sunny";
            break;
        case WeatherTypeCloudy:
            iconImageName = @"Cloudy";
            break;
        case WeatherTypeRain:
            iconImageName = @"Rainy";
            break;
        case WeatherTypeSnow:
            iconImageName = @"Cloudy_Snowy";
            break;
        case WeatherTypeWind:
            iconImageName = @"Sunny_Foggy";
            break;
    }

    UIImage *image = nil;
    if (iconImageName) {
        image = [UIImage imageNamed: iconImageName];
    }

    return image;
}

+ (NSString *) captionForWeatherType: (WeatherType)weatherType {
    return nil;
}


@end