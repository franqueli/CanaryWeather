//
//  WeatherSummaryCell.h
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/28/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanaryWeather+CoreDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherSummaryCell : UICollectionViewCell

@property (nonatomic, strong) ForecastDataPoint *forecastData;

@end

NS_ASSUME_NONNULL_END
