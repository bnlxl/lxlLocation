
//

#import "Example1Controller.h"
#import "MMLocationManager.h"

@interface Example1Controller ()

@end

@implementation Example1Controller

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([MMLocationManager significantLocationChangeMonitoringAvailable]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    [[MMLocationManager sharedManager] requestAlwaysAuthorization];
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    [[MMLocationManager sharedManager] setAllowsBackgroundLocationUpdates:YES];
#endif
    [[MMLocationManager sharedManager] startUpdatingLocation];
    
    [[MMLocationManager sharedManager] startMonitoringSignificantLocationChanges];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
