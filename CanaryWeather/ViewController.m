//
//  ViewController.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/26/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "ViewController.h"
#import "CanaryWeather+CoreDataModel.h"
#import "DataController.h"
#import "WeatherSummaryCell.h"
#import <Corelocation/CoreLocation.h>

@interface ViewController () {
    CLLocationCoordinate2D _locationCoordinate;
}
// TODO Add CollectionView reference and populate collectionview
@property (nonatomic, strong) IBOutlet UILabel *lastUpdatedLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSFetchedResultsController<ForecastDataPoint *> *resultsController;

@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self setupFetchedResultsController];

    // Use corelocation to get latitude and longitude
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}

- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];

    [self checkLocationAuthorization];
}

- (void) setupFetchedResultsController {
    // Get the newest ForecastLocation object
    NSFetchRequest<ForecastLocation *> *locationFetchRequest = [ForecastLocation fetchRequest];
    locationFetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey: @"creationDate" ascending: YES]];

    NSError *error = nil;
    NSArray <ForecastLocation *>*results = [_dataController.viewContext executeFetchRequest:locationFetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching ForecastLocation objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();         // TODO: Alert user to the error
    }

    // Setup fetchedresultscontroller with the list of ForecastDataPoint objects
    ForecastLocation *forecastLocation = [results firstObject];

    if (forecastLocation) {
        NSFetchRequest *fetchRequest = [ForecastDataPoint fetchRequest];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"location == %@", forecastLocation];
        fetchRequest.predicate = predicate;
        fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey: @"time" ascending: YES]];

        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest managedObjectContext: _dataController.viewContext
                sectionNameKeyPath: nil cacheName: nil];        // TODO add a cachename
        _resultsController.delegate = self;

        error = nil;
        [_resultsController performFetch: &error];
        if (error) {
            NSLog(@"The fetch could not be performed: %@", error.localizedDescription);
        }
    }
}

- (void) placeNameForCurrentLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if (_locationManager.location) {
        [geocoder reverseGeocodeLocation: _locationManager.location completionHandler: ^(NSArray<CLPlacemark *> *placemarks, NSError *error) {
            if (error == nil) {
                CLPlacemark *firstPlaceMark = [placemarks firstObject];
                self.navigationItem.title = [NSString stringWithFormat: @"Weather for %@", [firstPlaceMark locality]];
            }
        }];
    }
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
    [self placeNameForCurrentLocation];
}

- (void) locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status {
    [self  checkLocationAuthorization];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void) controller: (NSFetchedResultsController *)controller didChangeSection: (id <NSFetchedResultsSectionInfo>)sectionInfo
            atIndex: (NSUInteger)sectionIndex forChangeType: (NSFetchedResultsChangeType)type {

}

- (void) controller: (NSFetchedResultsController *)controller didChangeObject: (id)anObject
        atIndexPath: (nullable NSIndexPath *)indexPath forChangeType: (NSFetchedResultsChangeType)type
       newIndexPath: (nullable NSIndexPath *)newIndexPath {

    switch (type){
        case NSFetchedResultsChangeInsert:
            // TODO update collectionview
            break;
        case NSFetchedResultsChangeDelete:
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

/*
 *
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNotebook = fetchedResultsController.object(at: indexPath)



 *
 */



#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView: (UICollectionView *)collectionView numberOfItemsInSection: (NSInteger)section {
    return [_resultsController.sections[section] numberOfObjects];
}

- (__kindof UICollectionViewCell *) collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath: (NSIndexPath *)indexPath {
    ForecastDataPoint *forecastDataPoint = [_resultsController objectAtIndexPath: indexPath];

    WeatherSummaryCell *weatherCell = [collectionView dequeueReusableCellWithReuseIdentifier: @"WeatherCell" forIndexPath: indexPath];
    weatherCell.forecastData = forecastDataPoint;

    return weatherCell;
}

- (CGSize) collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *)indexPath {

    CGSize result = CGSizeMake(collectionView.frame.size.width - 10.0, 60.0);

    return result;
}


@end
