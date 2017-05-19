
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface MMLocationManager : CLLocationManager

+ (instancetype)sharedManager;

@property (nonatomic, assign) CGFloat minSpeed;
@property (nonatomic, assign) CGFloat minFilter;
@property (nonatomic, assign) CGFloat minInteval;

@end
