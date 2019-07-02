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


- (void) viewDidLoad {
    [super viewDidLoad];

    NSDateFormatter *dateFormatter = [ForecastDetailTableViewController dateFormatter];

    _dateLabel.text = [dateFormatter stringFromDate: _forecastDataPoint.time];
    _conditionsImageView.image = [ForecastViewModel imageForWeatherType: _forecastDataPoint.weatherType];
    _conditionsLabels.text = [ForecastViewModel captionForWeatherType: _forecastDataPoint.weatherType];

    _highTempLabel.text = [NSString stringWithFormat: @"%.0f°", _forecastDataPoint.temperatureMax];
    _lowTempLabel.text = [NSString stringWithFormat: @"%.0f°", _forecastDataPoint.temperatureMin];
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
