//
//  WeatherSummaryCell.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/28/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "WeatherSummaryCell.h"
#import "ForecastDataPoint+Extension.h"

@interface WeatherSummaryCell()

@property(nonatomic, strong) UIImageView *iconImageView;

@end

@implementation WeatherSummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
/*
 WeatherTypeUnknown,
 WeatherTypeSunny,
 WeatherTypeCloudy,
 WeatherTypeRain,
 WeatherTypeSnow,
 WeatherTypeWind

 */
    
//    switch ([_forecastData weatherType]) {
//        case <#constant#>:
//            <#statements#>
//            break;
//            
//        default:
//            break;
//    }
    
}


- (void) setForecastData: (ForecastDataPoint *)forecastData {
    _forecastData = forecastData;

    
}


@end
