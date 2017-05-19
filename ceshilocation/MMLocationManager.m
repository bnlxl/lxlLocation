
//

#import "MMLocationManager.h"

@interface MMLocationManager()<CLLocationManagerDelegate>

//@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;

@end

@implementation MMLocationManager

+ (instancetype)sharedManager
{
    static MMLocationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MMLocationManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.minSpeed = 3;
        self.minFilter = 50;
        self.minInteval = 10;
//        [self startMonitoringSignificantLocationChanges];
        self.delegate = self;
        self.distanceFilter  = self.minFilter;
        self.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    
    NSLog(@"%@",location);
    
    [self adjustDistanceFilter:location];
    [self uploadLocation:location];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{}

//-(void)stopMonitoringSignificantLocationChanges{
//    [self stopMonitoringSignificantLocationChanges];
//}

/**
 *  规则: 如果速度小于minSpeed m/s 则把触发范围设定为50m
 *  否则将触发范围设定为minSpeed*minInteval
 *  此时若速度变化超过10% 则更新当前的触发范围(这里限制是因为不能不停的设置distanceFilter,
 *  否则uploadLocation会不停被触发)
 */
- (void)adjustDistanceFilter:(CLLocation*)location
{
//    NSLog(@"adjust:%f",location.speed);
    
    if ( location.speed < self.minSpeed )
    {
        if ( fabs(self.distanceFilter-self.minFilter) > 0.1f )
        {
            self.distanceFilter = self.minFilter;
        }
    }
    else
    {
        CGFloat lastSpeed = self.distanceFilter/self.minInteval;
        
        if ( (fabs(lastSpeed-location.speed)/lastSpeed > 0.1f) || (lastSpeed < 0) )
        {
            CGFloat newSpeed  = (int)(location.speed+0.5f);
            CGFloat newFilter = newSpeed*self.minInteval;
            
            self.distanceFilter = newFilter;
        }
    }
}


//这里仅用本地数据库模拟上传操作
- (void)uploadLocation:(CLLocation*)location
{
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"caches:%@",caches);
    NSDate*currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss SS"];
    NSString *dateStr = [dateFormatter stringFromDate:currentDate];
    
    NSLog(@"纬度=========%f 经度===========%f",location.coordinate.latitude,location.coordinate.longitude);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [userDefaults objectForKey:@"UserDefaultLocation"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:location.coordinate.latitude],@"latitude",[NSNumber numberWithDouble:location.coordinate.longitude],@"longitude",dateStr,@"time", nil];
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
    
#warning 模拟上传
//    NSLog(@"uploadLocation");
//    
//    MMLoc *loc = [MMLoc new];
//    loc.date       = [NSDate date];
//    loc.background = ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground);
//    loc.loc        = [NSString stringWithFormat:@"speed:%.0f filter:%.0f",location.speed,self.distanceFilter];
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    [realm transactionWithBlock:^{
//        [realm addObject:loc];
//        
//    }];
    
#warning 如果有较长时间的操作 比如HTTP上传 请使用beginBackgroundTaskWithExpirationHandler
//    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive )
//    {
//        //TODO HTTP upload
//        
//        [self endBackgroundUpdateTask];
//    }
//    else//后台定位
//    {
//        //假如上一次的上传操作尚未结束 则直接return
//        if ( self.taskIdentifier != UIBackgroundTaskInvalid )
//        {
//            return;
//        }
//        
//        [self beingBackgroundUpdateTask];
//        
//        //TODO HTTP upload
//        //上传完成记得调用 [self endBackgroundUpdateTask];
//    }
    
}




//- (void)beingBackgroundUpdateTask
//{
//    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        [self endBackgroundUpdateTask];
//    }];
//}
//
//- (void)endBackgroundUpdateTask
//{
//    if ( self.taskIdentifier != UIBackgroundTaskInvalid )
//    {
//        [[UIApplication sharedApplication] endBackgroundTask: self.taskIdentifier];
//        self.taskIdentifier = UIBackgroundTaskInvalid;
//    }
//}

@end
