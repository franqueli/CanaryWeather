//
//  ForecastDataSource.h
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/27/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class ForecastDataSource;
@class DataController;

@protocol ForecastDataSourceDelegate

- (void) datasource: (ForecastDataSource *)dataSource didFinishWithInfo: (NSDictionary *)info;
- (void) datasource: (ForecastDataSource *)dataSource didFailWithInfo: (NSDictionary *)info;

@end


@interface ForecastDataSource : NSObject

@property (nonatomic, weak) id <ForecastDataSourceDelegate> delegate;
@property (nonatomic, strong) DataController *dataController;

- (void) loadForecastForLatitude: (double)latitude longitude: (double)longitude;

@end
