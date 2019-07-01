//
//  ForecastDataSource.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/27/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ForecastDataSource.h"
#import "CanaryWeather+CoreDataModel.h"
#import "DataController.h"

static NSString *const FORECAST_URL_FORMAT = @"https://api.darksky.net/forecast/%@/%.4f,%.4f?exclude=minutely,alerts,flags,hourly";

@interface ForecastDataSource ()

@end


@implementation ForecastDataSource

- (void) loadForecastForLatitude: (double)latitude longitude: (double)longitude {
    NSString *apiKey = [[NSBundle mainBundle] infoDictionary][@"ForecastIOKey"];
    NSString *forecastURLString = [NSString stringWithFormat: FORECAST_URL_FORMAT, apiKey, latitude, longitude];

    NSURL *forecastURL = [[NSURL alloc] initWithString: forecastURLString];

    NSLog(@"URL: %@", forecastURL);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL: forecastURL completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

        if (error) {
            NSLog(@"*** Forecast API Failed: %@", error);
            [self notifyDelegateFailedWithInfo: @{@"error": error}];
            return;
        }

        if ([httpResponse statusCode] != 200) {
            NSLog(@"*** Forecast API Failed Code: %ld", (long)[httpResponse statusCode]);
            [self notifyDelegateFailedWithInfo: @{@"error": [NSString stringWithFormat: @"Bad http status: %ld", (long)[httpResponse statusCode]]}];
            return;
        }

        [self processResponseData: data];
    }];

    [task resume];
}

- (void) processResponseData: (NSData *)responseData {
    // Make sure this is processing on a background thread
#ifdef DEBUG
    NSLog(@"*** Data: %@ ***", [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding]);
#endif

    NSError *error = nil;
    id jsonRoot = [NSJSONSerialization JSONObjectWithData: responseData options: 0 error: &error];
    if (error) {
        NSLog(@"Error processing JSON %@", error.localizedDescription);
        [self notifyDelegateFailedWithInfo: @{@"error": error.localizedDescription}];
        return;
    }

    if (![jsonRoot isKindOfClass: [NSDictionary class]]) {
        NSLog(@"Error processing JSON. Expected dictionary root object.");
        [self notifyDelegateFailedWithInfo: @{@"error": @"Unexpected response"}];
        return;
    }

    NSDictionary *jsonDict = (NSDictionary *)jsonRoot;

    ForecastLocation *forecastLocation = [self forecastLocationWithDictionary: jsonDict];

    if (forecastLocation == nil) {
        [self resetContext];
        [self notifyDelegateFailedWithInfo: @{@"error": @"Error saving data"}];

        return;
    }

    NSArray<NSDictionary *> *dailyData = jsonDict[@"daily"][@"data"];

    for (NSDictionary *infoForDay in dailyData) {
        [self addForecastWithInfo: infoForDay forLocation: forecastLocation];
    }

    [self notifyDelegateFinishedWithInfo: @{@"forecast": forecastLocation}];
}

- (void) notifyDelegateFinishedWithInfo: (NSDictionary *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_delegate datasource: self didFinishWithInfo: info];
    });
}

- (void) notifyDelegateFailedWithInfo: (NSDictionary *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_delegate datasource: self didFailWithInfo: info];
    });
}

- (ForecastLocation *) forecastLocationWithDictionary: (NSDictionary *)props {
    // forecastLocation should have a date
    ForecastLocation *forecastLocation = [[ForecastLocation alloc] initWithContext: _dataController.backgroundContext];
    NSNumber *latitude = props[@"latitude"];
    NSNumber *longitude = props[@"longitude"];
    NSString *timezone = props[@"timezone"];

    forecastLocation.creationDate = [NSDate date];
    forecastLocation.latitude = [latitude doubleValue];
    forecastLocation.longitude = [longitude doubleValue];
    forecastLocation.timezone = timezone;

    NSError *error = nil;
    [_dataController.backgroundContext save: &error];
    if (error) {
        // TODO : how should we handle this? Return nil?
        NSLog(@"Error saving ForecastLocation");
    }

    return forecastLocation;
}

- (ForecastDataPoint *) addForecastWithInfo: (NSDictionary *)infoForDay forLocation: (ForecastLocation *)forecastLocation {
    ForecastDataPoint *forecastDataPoint = [[ForecastDataPoint alloc] initWithContext: _dataController.backgroundContext];

    forecastDataPoint.icon = infoForDay[@"icon"];
    forecastDataPoint.summary = infoForDay[@"summary"];
    forecastDataPoint.temperatureMax = [(NSNumber *)infoForDay[@"temperatureMax"] doubleValue];
    forecastDataPoint.temperatureMin = [(NSNumber *)infoForDay[@"temperatureMin"] doubleValue];
    forecastDataPoint.time = [[NSDate alloc] initWithTimeIntervalSince1970: [(NSNumber *)infoForDay[@"time"] integerValue]];

    forecastDataPoint.location = forecastLocation;

    NSError *error = nil;
    [_dataController.backgroundContext save: &error];
    if (error) {
        // TODO : how should we handle this? Return nil?
        NSLog(@"Error saving ForecastDataPoint");
    }

    return forecastDataPoint;
}

- (void) resetContext {
    [_dataController.backgroundContext reset];
}

@end
