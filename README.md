# FJCityChoose
城市选择器
<div align="center">
    <img src="https://github.com/coolFangjun/biny.github.io/blob/master/1.gif">
</div>

####使用方法

拖入FJChooseCity到项目中，导入

```
#import"ChooseCityViewController.h"

/**
 *  选中城市后的回调
 */
@property (strong,nonatomic)void (^selectCity)(ChooseCityModel *model);

```

调用方法

创建一个selectCity回调的Block,把Block传入控制器中

```
- (void)selectCity:(void (^)(ChooseCityModel *))selctCity{
    ChooseCityViewController *chooseCityVC = [[ChooseCityViewController alloc]init];
    chooseCityVC.selectCity = selctCity;
    [self.navigationController pushViewController:chooseCityVC animated:YES];
    
}

```
```
[self selectCity:^(ChooseCityModel *selctCity) {
        
        NSLog(@"%@",selctCity.name);
        //通过block的回调，拿到选择的城市名称
        
    }];



```
