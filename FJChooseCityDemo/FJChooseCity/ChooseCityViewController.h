//
//  ChooseCityViewController.h
//  TibetanProject
//
//  Created by 小宸宸Dad on 16/1/26.
//  Copyright © 2016年 fj. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ChooseCityModel.h"
@interface ChooseCityViewController : UIViewController

/**
 *  选中城市后的回调
 */
@property (strong,nonatomic)void (^selectCity)(ChooseCityModel *model);


@end
