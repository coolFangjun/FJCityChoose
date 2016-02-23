//
//  ChooseCityModel.h
//  TibetanProject
//
//  Created by 小宸宸Dad on 16/1/26.
//  Copyright © 2016年 fj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseCityModel : NSObject

/**
 *  城市名
 */
@property (copy,nonatomic)NSString *name;

/**
 *  城市名（藏文）
 */
@property (copy,nonatomic)NSString *zangwen;


/**
 *  城市名（拼音）
 */
@property (copy,nonatomic)NSString *pinyin;

/**
 *  藏文序列（类似 a b c d e 。。。。）
 */
@property (copy,nonatomic)NSString *zangpy;


@end
