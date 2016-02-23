//
//  SqlDataBase.m
//  TibetanProject
//
//  Created by 小宸宸Dad on 16/1/23.
//  Copyright © 2016年 fj. All rights reserved.
//

#import "SqlDataBase.h"

#define Set_SQL_Path [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"systemSet.sqlite"]
#define setDataBase @"systemSet"

@interface SqlDataBase (){
    
    sqlite3 *db;
    
}

@end
@implementation SqlDataBase


- (BOOL)open:(NSString *)sqlPath{
    
  
    
    BOOL result;
    if (sqlite3_open([sqlPath UTF8String], &db) != SQLITE_OK) {
        
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
        
    }else{
        
        result = YES;
    }
    
    return  result;
}

- (BOOL)close{
    
    
    return sqlite3_close(db);
    
}



- (BOOL)execSql:(NSString *)sql{
    
    BOOL result;
    char *error;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error)!= SQLITE_OK) {
        //        NSLog(@"%s",error);
        sqlite3_close(db);
        NSLog(@"执行%@语句失败",sql);
        
    }else{
        
        result = YES;
    }
    
    return  result;
    
    
    
}

- (NSArray *)get_table:(NSString *)sql{
    
    
    int row = 0;
    int column = 0;
    char*    errorMsg = NULL;
    char**    dbResult = NULL;
    NSMutableArray *    array = [[NSMutableArray alloc] init];
    if(sqlite3_get_table(db, [sql UTF8String], &dbResult, &row,&column,&errorMsg ) == SQLITE_OK)
    {
        if (0 == row) {
            sqlite3_close(db);
            return nil;
        }
        int index = column;
        for(int i =0; i < row ; i++ ) {
            NSMutableDictionary*    dic = [[NSMutableDictionary alloc] init];
            for(int j =0 ; j < column; j++ ) {
                if (dbResult[index]) {
                    NSString*    value = [[NSString alloc] initWithUTF8String:dbResult[index]];
                    NSString*    key = [[NSString alloc] initWithUTF8String:dbResult[j]];
                    [dic setObject:value forKey:key];
                }
                
                index ++;
            }
            [array addObject:dic];
        }
        
    }else{
        
        NSLog(@"%s",errorMsg);
    }
    return array;
}


//发送消息写入数据到数据库

+ (void)writeDataToDataBase:(NSDictionary *)dataDic  success:(void(^)(NSDictionary *statusDict))success failure:(void(^)(NSError *error))failure{
    

    NSLog(@"%@",Set_SQL_Path);
    NSInteger setType = [dataDic[@"setType"]integerValue];
    switch (setType) {
        case 1:
            //服务器相关的配置
        {
            SqlDataBase *sql = [[SqlDataBase alloc]init];
            [sql open:Set_SQL_Path];
            
            NSString *name              = dataDic[@"name"];
            NSString *computerIpaddress = dataDic[@"computerIpaddress"];
            NSString *computerMac       = dataDic[@"computerMac"];
            NSInteger is_video          = [dataDic[@"is_video"]integerValue];
            NSString *sqlStr = [NSString stringWithFormat:
                                @"INSERT INTO '%@' ('%@', '%@','%@','%@') VALUES ('%@', '%@', '%@','%@')",
                                setDataBase, @"name",@"computerIpaddress",@"computerMac",@"is_video",name,computerIpaddress,computerMac,@(is_video)];
            if ([sql execSql:sqlStr]) {
                
                success(@{@"success":@"yes"});
            }else{
            
                failure([[NSError alloc]init]);
            }
        
        }
            break;
        case 2:
            //投影机相关的配置
        {
            SqlDataBase *sql = [[SqlDataBase alloc]init];
            [sql open:Set_SQL_Path];
            NSString *name         = dataDic[@"name"];
            NSString *projectorCmd = dataDic[@"projectorCmd"];
            NSString *sqlStr = [NSString stringWithFormat:
                                @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                                setDataBase, @"name",@"projectorCmd",name,projectorCmd];
            if ([sql execSql:sqlStr]) {
                
                success(@{@"success":@"yes"});
            }else{
                
                failure([[NSError alloc]init]);
            }
            
        }
            break;
        default:
            break;
    }
    

}






#pragma mark - 删除数据库
+ (void)deleteSelectMessage:(NSInteger)message_ID{
    
    



}













#pragma mark - 从数据库获得数据
+ (void)getDataFromSQLData:(GetDataType)type this_user_ID:(NSInteger)this_user_ID    startData:(NSInteger )startData overData:(NSInteger)overData success:(void(^)(NSArray *statusArray))success failure:(void(^)(NSError *error))failure{



}

- (NSInteger)getLast_insert_rowid{


    NSInteger row = sqlite3_last_insert_rowid(db);
    NSLog(@"%ld",row);
    
    return row;


}

#pragma mark - 更新数据库表
+ (BOOL)deleteDataBase{
    
    return YES;
}


#pragma mark - 创建数据库表
+ (BOOL)creartDataBase{
    
    
    SqlDataBase *systemSql = [[SqlDataBase alloc]init];
    
    [systemSql open:Set_SQL_Path];
    
    
    NSString *systemSqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, picImage TEXT, projectorNumber INTEGER,projectorCmd TEXT,computerNumber INTEGER,computerIpaddress TEXT,computerMac TEXT,is_video INTEGER)",setDataBase];
    
    BOOL result = [systemSql execSql:systemSqlStr];
    
    [systemSql close];
    return result;
    
}


@end
