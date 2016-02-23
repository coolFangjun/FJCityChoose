//
//  CCLocationManager.h
//  MMLocationManager
//
//  Created by yuanmc on 15-11-10.
//  Copyright (c) 15年 yuanmc. All rights reserved.
//
/*******************************

 ********************************/
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define  CCLastLongitude @"CCLastLongitude"
#define  CCLastLatitude  @"CCLastLatitude"
#define  CCLastCity      @"CCLastCity"
#define  CCLastAddress   @"CCLastAddress"

typedef void (^LocationBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);
typedef void(^NSStringBlock)(NSString *cityString);
typedef void(^NSStringBlock)(NSString *addressString);

@interface CCLocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,strong)NSString *lastCity;
@property (nonatomic,strong) NSString *lastAddress;

@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;

@property(nonatomic,assign)BOOL showTips;//如果没有打开定位，yes 的时候提示 ，no  的时候不提示

+ (CCLocationManager *)shareLocation;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock;



/**
 *  获取坐标和详细地址
 *
 *  @param locaiontBlock locaiontBlock description
 *  @param addressBlock  addressBlock description
 */
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock;

/**
 *  获取详细地址
 *
 *  @param addressBlock addressBlock description
 */
- (void) getAddress:(NSStringBlock)addressBlock;

/**
 *  获取城市
 *
 *  @param cityBlock cityBlock description
 */
- (void) getCity:(NSStringBlock)cityBlock;

///**
// *  获取城市和定位失败
// *
// *  @param cityBlock  cityBlock description
// *  @param errorBlock errorBlock description
// */
//- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock;







@end
