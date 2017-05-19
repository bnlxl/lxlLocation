
//

#import "AppDelegate.h"
#import "AppDelegate.h"
#import "Example1Controller.h"
#import "MMLocationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setViewController];
    [self fileInDoc:launchOptions];
    
    
    
    
    
    return YES;
}

- (void)setViewController{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *vc1 = [Example1Controller new];
    
    vc1.tabBarItem.title = @"Map";
    
    
    self.window.rootViewController = vc1;
    
    [self.window makeKeyAndVisible];
    
}

- (void)fileInDoc:(NSDictionary *)launchOptions{
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        
//        MMLocationManager *locationManager = [MMLocationManager sharedManager];
        NSDate*currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:currentDate];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *arr = [userDefaults objectForKey:@"UserDefaultLocation"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[MMLocationManager sharedManager].location.coordinate.latitude],@"latitude",[NSNumber numberWithDouble:[MMLocationManager sharedManager].location.coordinate.longitude],@"longitude",dateStr,@"time", nil];
        if (arr) {
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:arr];
            [mArr addObject:dic];
            arr = mArr;
        }else{
            arr = [NSArray arrayWithObject:dic];
        }
        NSLog(@"%@",arr);
        [userDefaults setObject:arr forKey:@"UserDefaultLocation"];
        [userDefaults synchronize];
        
    }
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        [[MMLocationManager sharedManager] requestAlwaysAuthorization];
#endif
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
        [[MMLocationManager sharedManager] setAllowsBackgroundLocationUpdates:YES];
#endif
        
        [[MMLocationManager sharedManager] startMonitoringSignificantLocationChanges];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
