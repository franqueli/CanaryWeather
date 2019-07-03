Sample iOS Weather Application

This project was built with XCode 10.2.1 and targets iOS 12.2

The application uses the darksky.net [api](https://darksky.net/dev/docs)

ForecastListViewController - Initial view controller. Displays forecast for the week using a collection view 
ForecastDetailTableViewController - Displays details of a selected day<br>
ForecastViewModel - Utility to map from types to user visible strings and images<br>
DataController - Centralized coredata configuration<br>
ForecastDataSource - Handles calls to the darksky api and persisting to coredata.<br>
WeatherTransitionAnimator - Implements UIViewControllerAnimatedTransitioning for a custom UINavigation push<br>

The api key for the call to the darkskey api is set in the apps info.plist 'ForecastIOKey'

### TODO's
1. Clean up old persisted data
2. Store location name for use when the app is offline
3. Write unit tests