//
//  ChooseCityViewController.m
//  TibetanProject
//
//  Created by 小宸宸Dad on 16/1/26.
//  Copyright © 2016年 fj. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "SqlDataBase.h"
#import "Masonry.h"
#import "CCLocationManager.h"

//系统的屏幕宽度
#define ScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
//系统的屏幕高度
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)



@interface ChooseCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{

    
    
    
}



/**
 *  加载页面的View
 */
- (void)initlizeappance;

/**
 *  加载页面的数据
 */
- (void)initlizeDataSource;

/**
 *  数据源
 */
@property (copy,nonatomic)NSMutableArray *dataSource;


/**
 *  临时数据源
 */
@property (copy,nonatomic)NSMutableArray *tempDataArray;



/**
 *  首字母数据源
 */
@property (copy,nonatomic)NSMutableArray *arrayOfCharacters;



/**
 *  临时首字母数据源
 */
@property (copy,nonatomic)NSMutableArray *tempArrayOfCharacters;




/**
 *  搜索view
 */
@property (strong,nonatomic)UISearchBar *searchBar;

/**
 *  tableView
 */
@property (strong,nonatomic)UITableView *myTabeleView;

/**
 *  定位城市 4字
 */
@property (strong,nonatomic)UILabel *localCityStrLabel;

/**
 *  定位到的城市
 */
@property (strong,nonatomic)UILabel *localCityLabel;


@end



@implementation ChooseCityViewController


- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;


}


- (NSMutableArray *)tempDataArray{
    
    if (!_tempDataArray) {
        
        _tempDataArray = [NSMutableArray array];
    }
    return _tempDataArray;
    
    
}

- (NSMutableArray *)arrayOfCharacters{
    
    if (!_arrayOfCharacters) {
        
        _arrayOfCharacters = [NSMutableArray array];
    }
    return _arrayOfCharacters;
    
    
}

- (NSMutableArray *)tempArrayOfCharacters{
    
    if (!_tempArrayOfCharacters) {
        
        _tempArrayOfCharacters = [NSMutableArray array];
    }
    return _tempArrayOfCharacters;
    
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initlizeDataSource];
    [self initlizeappance];
}

- (UITableView *)myTabeleView{
    
    if (!_myTabeleView) {
        
        _myTabeleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+40,ScreenWidth, ScreenHeight - 40 - 64)];
        _myTabeleView.delegate = self;
        _myTabeleView.dataSource = self;
        _myTabeleView.backgroundColor = [UIColor clearColor];
        _myTabeleView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_myTabeleView];
    }
    return _myTabeleView;
    
    
    
}


- (UISearchBar *)searchBar{
    
    
    if (!_searchBar) {
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64,ScreenWidth, 40)];
        _searchBar.delegate = self;
        _searchBar.barTintColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.945 alpha:1.000];
        _searchBar.placeholder = @"搜索";
        _searchBar.tintColor = [UIColor redColor];
        
        [self.view addSubview:_searchBar];
        
    }
    return _searchBar;
    
    
}




- (void)initlizeDataSource{


    NSString *path = [[NSBundle mainBundle]pathForResource:@"meituan_cities" ofType:@"db"];
    NSLog(@"%@",path);
    SqlDataBase *sql = [[SqlDataBase alloc]init];
    [sql open:path];
    NSString *get_sql_Str = [NSString stringWithFormat:@"SELECT * FROM %@" ,@"city"];
    NSArray *getCityArray = [sql get_table:get_sql_Str];
    for (NSDictionary *dic in getCityArray) {
        
        
        ChooseCityModel *model = [[ChooseCityModel alloc]init];
        model.name             = dic[@"name"];
        model.zangwen          = dic[@"zangwen"];
        model.pinyin           = dic[@"pinyin"];
        model.zangpy           = dic[@"zangpy"];
        [self.dataSource addObject:model];
        [self.arrayOfCharacters addObject:[model.pinyin substringToIndex:1]];

        
        
    }
    NSSet *set = [NSSet setWithArray:self.arrayOfCharacters];
    self.arrayOfCharacters = [[set allObjects]mutableCopy];
        //排序
        self.arrayOfCharacters = [[self.arrayOfCharacters sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    self.tempArrayOfCharacters = [self.arrayOfCharacters mutableCopy];

    
//    if ([FJShareClass share].setAPPLange == SetLangeToChinese) {
    
        NSSortDescriptor *sortDescript = [[NSSortDescriptor alloc]initWithKey:@"pinyin" ascending:YES];
        NSArray *sortDescriptors       = [[NSArray alloc] initWithObjects:&sortDescript count:1];
        
        [self.dataSource sortUsingDescriptors:sortDescriptors];
//    }
    
    NSMutableArray *LetterResult = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString;
    
    //拼音分组
    for (ChooseCityModel* model in self.dataSource) {
        
        NSString *pinyin = nil;
        pinyin = [model.pinyin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:pinyin])
        {
            //分组
            item = [NSMutableArray array];
            [item  addObject:model];
            [LetterResult addObject:item];
            //遍历
            tempString = pinyin;
        }else//相同
        {
            
            [item  addObject:model];
        }
    }
    self.dataSource = [LetterResult mutableCopy];
    self.tempDataArray = [self.dataSource mutableCopy];
    
}






- (void)initlizeappance{

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择城市";
    [self.view addSubview:self.searchBar];
    UIView *cityBgView = [[UIView alloc]init];
    cityBgView.backgroundColor = [UIColor colorWithRed:0.922 green:0.918 blue:0.957 alpha:1.000];
    [self.view addSubview:cityBgView];
    self.localCityStrLabel = [[UILabel alloc]init];
    self.localCityStrLabel.text = @"城市定位";
    self.localCityStrLabel.textColor = [UIColor colorWithRed:0.408 green:0.408 blue:0.439 alpha:1.000];
    self.localCityStrLabel.font = [UIFont systemFontOfSize:12];
//    self.localCityStrLabel.backgroundColor = [UIColor colorWithRed:0.922 green:0.918 blue:0.957 alpha:1.000];
    [cityBgView addSubview:self.localCityStrLabel];
    
    self.localCityLabel = [[UILabel alloc]init];
    
    [[CCLocationManager shareLocation]getCity:^(NSString *addressString) {
        
    
        self.localCityLabel.text = addressString;
    }];
    
    
    self.localCityLabel.backgroundColor = [UIColor colorWithRed:0.996 green:1.000 blue:1.000 alpha:1.000];
    [self.view addSubview:self.localCityLabel];
    
    [self.view addSubview:self.myTabeleView];

    [cityBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.searchBar.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@33);
        
    }];
    
    [self.localCityStrLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(cityBgView.mas_centerY);
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(@9);
        
    }];
    
    [self.localCityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cityBgView.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@44);
        make.left.equalTo(@9);
        
    }];
    [self.myTabeleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.localCityLabel.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
        
    }];


}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count ;
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = self.dataSource[section];
    
    return array.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"cell";
    UITableViewCell *cell = [self.myTabeleView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //设置cell的元素的值
    [self setCellData:indexPath cell:cell];
    
    return cell;
    
    
}


- (void)setCellData:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell{
    
    ChooseCityModel *model = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = model.name;
    
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    
    return self.arrayOfCharacters;
    
}





- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSInteger count = 0;
    NSLog(@"%@",title);
    
    for(NSString *character in self.arrayOfCharacters)
        
    {
        
        if([character isEqualToString:title])
            
        {
            
            return count;
            
        }
        
        count ++;
        
    }
    
    return 0;
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if([self.arrayOfCharacters count]==0)
        
    {
        
        return @"";
        
    }
    
    return [self.arrayOfCharacters objectAtIndex:section];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //选中，回调
    self.selectCity(self.dataSource[indexPath.section][indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
    

    
}



- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"搜索:%@",searchText);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![searchText isEqualToString:@""]) {
            
            [self searchFriends:searchText];
        }else{
            self.arrayOfCharacters = [self.tempArrayOfCharacters mutableCopy];
            self.dataSource = self.tempDataArray;
            [self.myTabeleView reloadData];
        }
        
    });
    
    
}


- (void)searchFriends:(NSString *)inputStr{
    
    if (inputStr.length != 0) {
        
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < self.tempDataArray.count; i ++) {
            
            NSArray *resultArray = [self.tempDataArray[i]mutableCopy];
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 0; i < resultArray.count; i ++) {
                
                ChooseCityModel *model = resultArray[i];
                NSRange range1 = [model.name rangeOfString:inputStr];
                NSRange range2 = [model.pinyin rangeOfString:inputStr options:NSCaseInsensitiveSearch];
                if (range1.location!= NSNotFound||range2.location!= NSNotFound) {
                    if (self.dataSource.count != 0) {
                        self.dataSource = nil;
                        self.arrayOfCharacters = nil;
//                        [self.dataSource removeAllObjects];
//                        [self.arrayOfCharacters removeAllObjects];
                    }
                    [tempArray addObject:model];
                    if (model.pinyin.length != 0) {
                        
                        NSString *str = [model.pinyin substringToIndex:1];
                        [self.arrayOfCharacters addObject:str];
                    }else{
                        
                        [self.arrayOfCharacters addObject:@""];
                    }
                    
                    
                }
                
            }
            if (tempArray.count != 0) {
                [temp addObject:tempArray];
            }
            
        }
        self.dataSource = [temp mutableCopy];
        
    }else{
        

        self.dataSource= [self.tempDataArray mutableCopy];
        self.arrayOfCharacters = [self.tempArrayOfCharacters mutableCopy];
        
        
    }
    
    NSSet *set = [NSSet setWithArray:self.arrayOfCharacters];
    
    self.arrayOfCharacters = [[set allObjects]mutableCopy];
    
    [self.myTabeleView reloadData];
    
    
    
}





@end
