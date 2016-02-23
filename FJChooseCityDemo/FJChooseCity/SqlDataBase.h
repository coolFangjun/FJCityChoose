//
//  SqlDataBase.h
//  TibetanProject
//
//  Created by 小宸宸Dad on 16/1/23.
//  Copyright © 2016年 fj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@protocol SqlDataBaseDelegate <NSObject>


- (void)updateGroupTitle:(NSString *)name group_ID:(NSInteger)group_ID;


@end


typedef NS_ENUM(NSInteger, WriteToDataBaseType){

    FJWriteDataTypeSingle = 0,//单聊信息
    FJWriteDataTypeGroup,      //群聊信息
    FJWriteDataTypeSystem
    
};

typedef NS_ENUM(NSInteger, GetDataType){
    
    FJGetDataTypeSingle = 0,//单聊数据
    FJGetDataTypeGroup,      //群聊数据
    FJGetDataTypeSystem     //系统消息
};


/**
 *  更新群资料/好友资料
 */
typedef NS_ENUM(NSInteger,UpdateInfoType){
    
    UPFrendsInfo = 1,//更新好友的个人资料
    UPGroupInfo      //更新群的资料
};



@interface SqlDataBase : NSObject


@property (assign,nonatomic)id<SqlDataBaseDelegate> delegate;

//操作sql数据库


/**
 *  打开数据库，如果失败，则返回no,如果数据库不存在 则创建
 *
 */
- (BOOL)open:(NSString *)sqlPath;

- (BOOL)close;

/**
 *  执行sql数据
 *
 *  @param sql 执行的sql语句
 *
 *  @return 失败返回no
 */
- (BOOL)execSql:(NSString *)sql;

/**
 *  获取表的数据
 *
 *  @param sql sql语句
 *
 *  @return 表的数据
 */

- (NSArray *)get_table:(NSString *)sql;


/**
 *  获取最后一条插入的数据的id
 *
 *  @return 返回数据库的id
 */
- (NSInteger)getLast_insert_rowid;





/**
 *  写入数据到数据库
 *
 *  @param dataDic 写入到数据库的数据
 *  @param type     群聊和单聊信息
 *  @param success 写入成功的回调
 *  @param failure 写入失败的回调
 */
+ (void)writeDataToDataBase:(NSDictionary *)dataDic  success:(void(^)(NSDictionary *statusDict))success failure:(void(^)(NSError *error))failure;

/**
 *  从数据库获得数据
 *
 *  @param type         获得数据的类型
 *  @param this_user_ID 群id或者单聊用户id
 *  @param startData    从数据库第几行开始取
 *  @param overData     从数据库第几行结束 (startData=0，overData=0取数据库所有数据)
 *  @param success      取值成功的回调
 *  @param failure      取值失败的回调
 */
+ (void)getDataFromSQLData:(GetDataType)type this_user_ID:(NSInteger)this_user_ID    startData:(NSInteger )startData overData:(NSInteger)overData success:(void(^)(NSArray *statusArray))success failure:(void(^)(NSError *error))failure;



/**
 *  群聊通过message_id的起始位置从数据库获得数据
 *  @param this_id            群id
 *  @param startMessage_id    从数据库第几行开始取
 *  @param overMessage_id     从数据库第几行结束 (startData=0，overData=0取数据库所有数据)
 *  @param success            取值成功的回调
 *  @param failure            取值失败的回调
 */
+ (void)getDataFromSQLData:(NSInteger)this_id startMessage_id:(NSInteger)startMessage_id  overMessage_id:(NSInteger)overMessage_id success:(void(^)(NSArray *statusArray))success failure:(void(^)(NSError *error))failure;

/**
 *  更新发送消息的状态到数据库
 *
 *  @param type  需要更新哪个数据库
 *  @param sqlID 更新的数据库的主键ID
 *  @pram updateState 更新的键值的值
 *
 *  @return 更新成功 return yes
 */
+ (BOOL)updateSqlData:(GetDataType)type sqlID:(NSInteger)sqlID updateState:(NSInteger)updateState;


/**
 *  更新系统消息中是否已经拒绝、同意加为好友
 *
 *  @param this_user_id 好友的id
 *
 *  @return yes
 */
+ (BOOL)updateFrendData:(NSInteger)this_user_id is_frend:(NSInteger)is_frend;


/**
 *  删除最近联系人中的群组
 *
 *  @param group_ID 群组id
 *
 *  @return 删除状态
 */
+ (BOOL)deleteSqlData:(NSString *)group_ID;

/**
 *  删除最近联系人中的单聊
 *
 *  @param to_user_id 要删除的单聊的id
 *
 *  @return 删除状态
 */
+ (BOOL)deleteSingle:(NSString *)to_user_id;


/**
 *  删除最近联系人中的系统消息
 *
 *
 *  @return 删除状态
 */
+ (BOOL)deleteSystem;


/**
 *  删除选中的消息
 *
 *  @param message_ID 选中的消息id
 *
 */
+ (void)deleteSelectMessage:(NSInteger)message_ID type:(GetDataType)type;


/**
 *  删除历史记录
 *
 *  @param this_id 要删除的历史记录的id
 *  @param type    要删除群的历史记录还是单聊的历史记录
 */
+ (void)deleteAllMessage:(NSInteger )this_id type:(GetDataType)type success:(void(^)(BOOL result))success;


/**
 *  更新最近联系人的最新聊天记录
 *
 *  @param type 更新的消息类型
 *
 */
//+ (void)updateMessage:(GetDataType)type message:(FJChatMessage *)message flag:(NSInteger)flag;


/**
 *  消息置顶/取消置顶
 *
 *  @param is_top       消息是否置顶
 *  @param this_id      需要置顶的消息的user_id
 *  @param type         是群消息置顶还是单聊消息置顶
 */
+ (void)messgaeTopNew:(NSInteger)is_top this_id:(NSInteger)this_id type:(GetDataType)type  topSuccess:(void(^)(BOOL result))success;




/**
 *  修改群资料/好友资料
 *
 *  @param this_id        群的id/好友的id
 *  @param nickNameOrGroupName    群名称/好友备注
 *  @param updateType     UPFrendsInfo 更新好友
 *  @param header_pic_Url 群/好友的最新头像
 *
 *  @return 成功返回yes
 */

+ (BOOL)updateRecentContact:(NSInteger)this_id nickNameOrGroupName:(NSString *)name updateType:(UpdateInfoType)updateType header_pic_Url:(NSString *)header_pic_Url;


/**
 *  更新语音消息的状态
 *
 *  @param updateType 更新的状态
 *  @param message_id 需要更新的语音消息数据库的id
 */
+ (void)updateVoiceState:(UpdateInfoType)updateType this_id:(NSInteger)this_id message_id:(NSInteger)message_id;

/**
 *  删除数据库
 *
 *  @return 返回是否删除成功
 */
+ (BOOL)deleteDataBase;


+ (BOOL)creartDataBase;


@end
