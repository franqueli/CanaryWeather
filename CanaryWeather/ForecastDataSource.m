//
//  ForecastDataSource.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/27/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForecastDataSource.h"

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

        NSLog(@"*** Data: %@ ***", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
    }];

    [task resume];
}


@end
