//
//  WeatherSummaryCell.m
//  CanaryWeather
//
//  Created by Franqueli Mendez on 6/28/19.
//  Copyright © 2019 Franqueli Mendez. All rights reserved.
//

#import "WeatherSummaryCell.h"
#import "ForecastDataPoint+Extension.h"
#import "ForecastViewModel.h"

@interface WeatherSummaryCell ()

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UILabel *highTempLabel;
@property (nonatomic, strong) IBOutlet UILabel *lowTempLabel;
@property (nonatomic, strong) IBOutlet UILabel *dayLabel;
@property (nonatomic, strong) IBOutlet UILabel *conditionsLabel;

@end

@implementation WeatherSummaryCell

+ (NSDateFormatter *) dateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.doesRelativeDateFormatting = YES;
    });

    return formatter;
}

- (void) awakeFromNib {
    [super awakeFromNib];

}

- (void) prepareForReuse {
    [super prepareForReuse];

    _iconImageView.image = nil;
    _dayLabel.text = @"";
    _highTempLabel.text = @"";
    _lowTempLabel.text = @"";
    _conditionsLabel.text = @"";
}


- (void) updateUI {
    _iconImageView.image = [ForecastViewModel imageForWeatherType: _forecastData.weatherType];

    NSDateFormatter *formatter = [WeatherSummaryCell dateFormatter];

    _dayLabel.text = [formatter stringFromDate: _forecastData.time];
    _highTempLabel.text = [NSString stringWithFormat: @"H: %.0f°", _forecastData.temperatureMax];
    _lowTempLabel.text = [NSString stringWithFormat: @"L: %.0f°", _forecastData.temperatureMin];
    _conditionsLabel.text = _forecastData.summary;
}

- (void) setForecastData: (ForecastDataPoint *)forecastData {
    _forecastData = forecastData;

    [self updateUI];
}


@end
