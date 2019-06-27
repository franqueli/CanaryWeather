//
//  ViewController.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/26/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "ViewController.h"
#import <Corelocation/CoreLocation.h>

@interface ViewController () {
    CLLocationCoordinate2D _locationCoordinate;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    // Use corelocation to get latitude and longitude
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}

- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];

    [self checkLocationAuthorization];
}

- (void) checkLocationAuthorization {
    CLAuthorizationStatus authorizationStatus = CLLocationManager.authorizationStatus;
    if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways
            && authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
        // Alert user that we need location to work
        // Don't start the location manager if we are not authorized
        NSLog(@"Alert user that location is required");
        [_locationManager requestWhenInUseAuthorization];
        return;
    }

    [_locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

- (void) locationManager: (CLLocationManager *)manager didUpdateLocations: (NSArray<CLLocation *> *)locations {
    CLLocation *lastLocation = locations.lastObject;
    _locationCoordinate = lastLocation.coordinate;

    NSLog(@"*** Latitude: %f Longitude: %f ***", _locationCoordinate.latitude, _locationCoordinate.longitude);
    [manager stopUpdatingLocation];
    // TODO: Stop spinner
    // TODO: Get location name from Coordinates
}

- (void) locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status {
    [self  checkLocationAuthorization];
}


@end
