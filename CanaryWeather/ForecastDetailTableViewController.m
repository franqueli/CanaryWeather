//
//  ForecastDetailTableViewController.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 7/1/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "ForecastDetailTableViewController.h"
#import "ForecastDataPoint+Extension.h"
#import "ForecastViewModel.h"

@interface ForecastDetailTableViewController ()

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *conditionsImageView;
@property (nonatomic, strong) IBOutlet UILabel *conditionsLabels;
@property (nonatomic, strong) IBOutlet UILabel *highTempLabel;
@property (nonatomic, strong) IBOutlet UILabel *lowTempLabel;

@property (nonatomic, strong) IBOutlet UILabel *summaryLabel;
@property (nonatomic, strong) IBOutlet UILabel *humidityValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *uvIndexValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *windSpeedValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *sunriseTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *sunsetTimeLabel;

@end

@implementation ForecastDetailTableViewController

+ (NSDateFormatter *) dateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.dateStyle = NSDateFormatterFullStyle;
    });

    return formatter;
}

+ (NSDateFormatter *) timeFormatter {
    static NSDateFormatter *timeFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.timeStyle = NSDateFormatterShortStyle;
        timeFormatter.dateStyle = NSDateFormatterNoStyle;
    });

    return timeFormatter;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    NSDateFormatter *dateFormatter = [ForecastDetailTableViewController dateFormatter];

    _dateLabel.text = [dateFormatter stringFromDate: _forecastDataPoint.time];
    _conditionsImageView.image = [ForecastViewModel imageForWeatherType: _forecastDataPoint.weatherType];
    _conditionsLabels.text = [ForecastViewModel captionForWeatherType: _forecastDataPoint.weatherType];

    _highTempLabel.text = [NSString stringWithFormat: @"%.0f°", _forecastDataPoint.temperatureMax];
    _lowTempLabel.text = [NSString stringWithFormat: @"%.0f°", _forecastDataPoint.temperatureMin];

    _summaryLabel.text = _forecastDataPoint.summary;

    _humidityValueLabel.text = [NSString stringWithFormat: @"%.0f%%", _forecastDataPoint.humidity * 100];
    _uvIndexValueLabel.text = [NSString stringWithFormat: @"%d", _forecastDataPoint.uvIndex];
    _windSpeedValueLabel.text = [NSString stringWithFormat: @"%.2f mph", _forecastDataPoint.windSpeed];

    NSDateFormatter *timeFormatter = [ForecastDetailTableViewController timeFormatter];
    _sunriseTimeLabel.text = [timeFormatter stringFromDate: _forecastDataPoint.sunriseTime];
    _sunsetTimeLabel.text = [timeFormatter stringFromDate: _forecastDataPoint.sunsetTime];
}

@end
