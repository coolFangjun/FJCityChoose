//
//  ViewController.m
//  FJChooseCityDemo
//
//  Created by 小宸宸Dad on 16/2/23.
//  Copyright © 2016年 fj. All rights reserved.
//

#import "ViewController.h"

#import "ChooseCityViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市选择器";
    
}

- (void)selectCity:(void (^)(ChooseCityModel *))selctCity{
    
    
    ChooseCityViewController *chooseCityVC = [[ChooseCityViewController alloc]init];
    chooseCityVC.selectCity = selctCity;
    [self.navigationController pushViewController:chooseCityVC animated:YES];
    
}



- (IBAction)chooseAction:(UIButton *)sender {
    
    
    [self selectCity:^(ChooseCityModel *selctCity) {
        
        NSLog(@"%@",selctCity);
        self.cityLabel.text = [NSString stringWithFormat:@"%@",selctCity.name];
        
    }];
    
    
    
}
@end
