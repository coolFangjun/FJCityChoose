//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by yuanmc on 15-11-10.
//  Copyright (c) 15年 yuanmc. All rights reserved.
//

#import "CCLocationManager.h"
#import "CLLocation+YCLocation.h"

#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)
#define ip4 ([UIScreen mainScreen].bounds.size.height == 480.0)
#define ip5 ([UIScreen mainScreen].bounds.size.height <= 667.0&&[UIScreen mainScreen].bounds.size.height>480.0)
#define PassIp6 ([UIScreen mainScreen].bounds.size.height >= 667.0)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
@interface CCLocationManager (){
    CLLocationManager *_manager;

}
@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;

@end

@implementation CCLocationManager

+ (CCLocationManager *)shareLocation{
	static dispatch_once_t pred = 0;
	__strong static id _sharedObject = nil;
	dispatch_once(&pred, ^{
		_sharedObject = [[self alloc]init];
	});
	return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCity = [standard objectForKey:CCLastCity];
        self.lastAddress=[standard objectForKey:CCLastAddress];
    }
    return self;
}
//获取经纬度
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}
//获取省市
- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

//- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
//{
//    self.cityBlock = [cityBlock copy];
//    self.errorBlock = [errorBlock copy];
//    [self startLocation];
//}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLLocation * marsLoction =   [location locationMarsFromEarth];


    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:marsLoction completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             _lastCity = placemark.locality;
             [standard setObject:_lastCity forKey:CCLastCity];//省市地址
             NSLog(@"______%@",_lastCity);
             _lastAddress = placemark.name;
             [standard setObject:_lastAddress forKey:CCLastAddress];//上次定位位置
             NSLog(@"______%@",_lastAddress);
         }
         if (_cityBlock) {
             _cityBlock(_lastCity);
             _cityBlock = nil;
         }
         if (_addressBlock) {
             _addressBlock(_lastAddress);
             _addressBlock = nil;
         }

         
     }];
    
    

    
    _lastCoordinate = CLLocationCoordinate2DMake(marsLoction.coordinate.latitude ,marsLoction.coordinate.longitude);
    if (_locationBlock) {
        _locationBlock(_lastCoordinate);
        _locationBlock = nil;
    }

    NSLog(@"%f--%f",marsLoction.coordinate.latitude,marsLoction.coordinate.longitude);
    [standard setObject:@(marsLoction.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(marsLoction.coordinate.longitude) forKey:CCLastLongitude];

    [manager stopUpdatingLocation];
    
}


-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        if (IS_IOS8) {
            [_manager requestAlwaysAuthorization];
        }
        _manager.distanceFilter=100;
        [_manager startUpdatingLocation];
    }
    else
    {
        
        NSLog(@"设置->隐私->打开定位");
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];

}
-(void)stopLocation
{
    _manager = nil;
}



@end
