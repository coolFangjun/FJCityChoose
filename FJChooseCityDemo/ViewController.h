//
//  ViewController.h
//  FJChooseCityDemo
//
//  Created by 小宸宸Dad on 16/2/23.
//  Copyright © 2016年 fj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)chooseAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

