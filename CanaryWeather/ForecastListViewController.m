//
//  ForecastListViewController.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/26/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "ForecastListViewController.h"
#import "CanaryWeather+CoreDataModel.h"
#import "DataController.h"
#import "WeatherSummaryCell.h"
#import "ForecastDataSource.h"
#import "ForecastDetailTableViewController.h"
#import "WeatherTransitionAnimator.h"
#import <Corelocation/CoreLocation.h>

@interface ForecastListViewController () <UINavigationControllerDelegate> { // TODO remove transitioning delegate
    CLLocationCoordinate2D _locationCoordinate;
}

@property (nonatomic, strong) ForecastDataSource *forecastDataSource;

@property (nonatomic, strong) IBOutlet UICollectionView *forecastCollectionView;
@property (nonatomic, strong) IBOutlet UILabel *lastUpdatedLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSFetchedResultsController<ForecastDataPoint *> *resultsController;
@property (nonatomic, strong) UIAlertController *alertVC;

//@property (nonatomic, strong) WeatherTransitioningDelegate *weatherTransitioningDelegate;

@end

@implementation ForecastListViewController

+ (NSDateFormatter *) dateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterShortStyle;
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.doesRelativeDateFormatting = YES;
    });

    return formatter;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self setupFetchedResultsController];

    // Use corelocation to get latitude and longitude
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;

    self.navigationController.delegate = self;
}

- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];

    [self checkLocationAuthorization];
}

- (void) prepareForSegue: (UIStoryboardSegue *)segue sender: (nullable id)sender {
    [super prepareForSegue: segue sender: sender];

    if ([segue.identifier isEqualToString: @"ForecastDetailSegue"]) {
        if ([sender isKindOfClass: [UICollectionViewCell class]]) {
            NSIndexPath *indexPath = [_forecastCollectionView indexPathForCell: (UICollectionViewCell *)sender];
            ForecastDetailTableViewController *detailViewController = segue.destinationViewController;

            ForecastDataPoint *forecastDataPoint = [_resultsController objectAtIndexPath: indexPath];
            detailViewController.forecastDataPoint = forecastDataPoint;
        }
    }
}

- (void) setupFetchedResultsController {
    // Get the newest ForecastLocation object
    NSFetchRequest<ForecastLocation *> *locationFetchRequest = [ForecastLocation fetchRequest];
    locationFetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey: @"creationDate" ascending: NO]];

    NSError *error = nil;
    NSArray <ForecastLocation *>*results = [_dataController.viewContext executeFetchRequest:locationFetchRequest error:&error];
    if (!results) {
        NSLog(@"Error fetching ForecastLocation objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();         // TODO: Alert user to the error
    }

    // Setup fetchedresultscontroller with the list of ForecastDataPoint objects
    ForecastLocation *forecastLocation = [results firstObject];

    if (forecastLocation) {
        _lastUpdatedLabel.text = [NSString stringWithFormat: @"Last Updated: %@", [[ForecastListViewController dateFormatter] stringFromDate: forecastLocation.creationDate]];

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

- (void) loadForecastData {
    self.forecastDataSource = [[ForecastDataSource alloc] init];
    _forecastDataSource.delegate = self;
    _forecastDataSource.dataController = _dataController;
    [_forecastDataSource loadForecastForLatitude: _locationCoordinate.latitude longitude: _locationCoordinate.longitude];
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManager: (CLLocationManager *)manager didUpdateLocations: (NSArray<CLLocation *> *)locations {
    CLLocation *lastLocation = locations.lastObject;
    _locationCoordinate = lastLocation.coordinate;

    [manager stopUpdatingLocation];

    [self loadForecastData];

    [self placeNameForCurrentLocation];
}

- (void) locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status {
    [self  checkLocationAuthorization];
}

//#pragma mark - NSFetchedResultsControllerDelegate
//
//- (void) controller: (NSFetchedResultsController *)controller didChangeSection: (id <NSFetchedResultsSectionInfo>)sectionInfo
//            atIndex: (NSUInteger)sectionIndex forChangeType: (NSFetchedResultsChangeType)type {
//
//    NSLog(@"**** FC SectionDidChange ****");
//}
//
//- (void) controller: (NSFetchedResultsController *)controller didChangeObject: (id)anObject
//        atIndexPath: (nullable NSIndexPath *)indexPath forChangeType: (NSFetchedResultsChangeType)type
//       newIndexPath: (nullable NSIndexPath *)newIndexPath {
//
//    NSLog(@"**** FC DidChangeObject ****");
//
//    switch (type){
//        case NSFetchedResultsChangeInsert:
//            // TODO update collectionview
//            break;
//        case NSFetchedResultsChangeDelete:
//            break;
//        case NSFetchedResultsChangeMove:
//            break;
//        case NSFetchedResultsChangeUpdate:
//            break;
//    }
//}
//
//- (void) controllerWillChangeContent: (NSFetchedResultsController *)controller {
//    NSLog(@"**** FC WillChangeContent ****");
//}
//
//- (void) controllerDidChangeContent: (NSFetchedResultsController *)controller {
//    NSLog(@"**** FC DidChangeContent ****");
//}

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

    CGSize result = CGSizeMake(collectionView.frame.size.width, 90.0);

    return result;
}


//- (void) collectionView: (UICollectionView *)collectionView didSelectItemAtIndexPath: (NSIndexPath *)indexPath {
//    ForecastDataPoint *forecastDataPoint = [_resultsController objectAtIndexPath: indexPath];
//
//    NSLog(@"*** ForeCast: %@ ***", forecastDataPoint.summary);
//
//    // TODO perform segue
//
//}


#pragma mark - ForecastDatasourceDelegate

- (void) datasource: (ForecastDataSource *)dataSource didFinishWithInfo: (NSDictionary *)info {
    [self setupFetchedResultsController];

    [_forecastCollectionView reloadData];
}

- (void) datasource: (ForecastDataSource *)dataSource didFailWithInfo: (NSDictionary *)info {
    BOOL allowRetry = YES;
    NSString *errorMessage = @"Service call failed. Tap ok to try again";
    id error = info[@"error"];


    if (error && [error isKindOfClass: [NSError class]]) {
        NSInteger errorCode = [(NSError *)error code];
        if (errorCode == NSURLErrorNotConnectedToInternet) {
            allowRetry = NO;
            errorMessage = [(NSError *)error localizedDescription];
        }
    }

    self.alertVC = [UIAlertController alertControllerWithTitle:@"Error"
                                   message: errorMessage
                                   preferredStyle:UIAlertControllerStyleAlert];

    if (allowRetry) {
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault
                                                              handler: ^(UIAlertAction *action) {
                                                                  [self loadForecastData];
                                                              }];
        [_alertVC addAction:defaultAction];
    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel
                                                         handler: nil];


    [_alertVC addAction:cancelAction];

    [self presentViewController:_alertVC animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *)navigationController
                                             animationControllerForOperation: (UINavigationControllerOperation)operation
                                                          fromViewController: (UIViewController *)fromVc
                                                            toViewController: (UIViewController *)toVc {
    id <UIViewControllerAnimatedTransitioning> animator = nil;
    switch (operation) {
        case UINavigationControllerOperationPush: {
            WeatherTransitionAnimator *transitionAnimator = [[WeatherTransitionAnimator alloc] init];
            transitionAnimator.presenting = YES;

            animator = transitionAnimator;
        }
            break;
        case UINavigationControllerOperationPop: {
            WeatherTransitionAnimator *transitionAnimator = [[WeatherTransitionAnimator alloc] init];
            transitionAnimator.presenting = NO;

            animator = transitionAnimator;
        }
            break;
        case UINavigationControllerOperationNone:
            break;
    }

    NSLog(@"*** Animator: %@ ", animator);
    return animator;
}


@end
