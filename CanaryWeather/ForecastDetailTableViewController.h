//
//  ForecastDetailTableViewController.h
//  CanaryWeather
//
//  Created by Franqueli Mendez on 7/1/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanaryWeather+CoreDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForecastDetailTableViewController : UITableViewController

@property (nonatomic, strong) ForecastDataPoint *forecastDataPoint;

@end

NS_ASSUME_NONNULL_END
