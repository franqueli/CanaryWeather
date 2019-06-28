//
//  ForecastDataSource.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/27/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForecastDataSource.h"
#import "CanaryWeather+CoreDataModel.h"
#import "DataController.h"

static NSString *const FORECAST_URL_FORMAT = @"https://api.darksky.net/forecast/%@/%.4f,%.4f?exclude=minutely,alerts,flags,hourly";

@interface ForecastDataSource()

@end


@implementation ForecastDataSource

- (void) loadForecastForLatitude: (double)latitude longitude: (double)longitude {
    latitude = 40.7128;
    longitude = -74.0060;

    // TODO Get API Key from elsewhere, maybe a info plist key
    NSString *forecastURLString = [NSString stringWithFormat: FORECAST_URL_FORMAT, @"", latitude, longitude];

    NSURL *forecastURL = [[NSURL alloc] initWithString: forecastURLString];

    NSLog(@"URL: %@", forecastURL);
    // FIXME specify application/json accept header
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL: forecastURL completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;      // TODO add check for type

        if (error) {
            // TODO: Call back failed on delegate
            NSLog(@"*** Forecast API Failed: %@", error.localizedDescription);
            return;
        }

        if ([httpResponse statusCode] != 200) {
            NSLog(@"*** Forecast API Failed Code: %ld", (long)[httpResponse statusCode]);
            // TODO: Call back failed on delegate
            return;
        }

        [self processResponseData: data];
    }];

    [task resume];
}

- (void) processResponseData:(NSData *)responseData {
    // Make sure this is processing on a background thread
#ifdef DEBUG
    NSLog(@"*** Data: %@ ***", [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding]);
#endif

    NSError *error = nil;
    id jsonRoot = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if (error) {
        NSLog(@"Error processing JSON %@", error.localizedDescription);
        return;
    }

    if (![jsonRoot isKindOfClass: [NSDictionary class]]) {
        NSLog(@"Error processing JSON. Expected dictionary root object. %@", error.localizedDescription);
        return;
    }

    NSDictionary *jsonDict = (NSDictionary *)jsonRoot;

    ForecastLocation *forecastLocation = [self forecastLocationWithDictionary: jsonDict];

    NSArray<NSDictionary *> *dailyData = jsonDict[@"daily"][@"data"];

    for (NSDictionary *infoForDay in dailyData) {
        [self addForecastWithInfo:infoForDay forLocation: forecastLocation];
    }
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
- (ForecastDataPoint *) addForecastWithInfo:(NSDictionary *)infoForDay forLocation: (ForecastLocation *)forecastLocation {
    ForecastDataPoint *forecastDataPoint = [[ForecastDataPoint alloc] initWithContext: _dataController.backgroundContext];

    forecastDataPoint.icon = infoForDay[@"icon"];
    forecastDataPoint.summary = infoForDay[@"summary"];
    forecastDataPoint.temperatureMax = [(NSNumber *)infoForDay[@"temperatureMax"] doubleValue];
    forecastDataPoint.temperatureMin = [(NSNumber *)infoForDay[@"temperatureMin"] doubleValue];
    forecastDataPoint.time = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate: [(NSNumber *)infoForDay[@"time"] integerValue]];

    forecastDataPoint.location = forecastLocation;

    NSError *error = nil;
    [_dataController.backgroundContext save: &error];
    if (error) {
        // TODO : how should we handle this? Return nil?
        NSLog(@"Error saving ForecastDataPoint");
    }

    return forecastDataPoint;
}

@end
