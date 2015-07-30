//
//  DataBase.m
//  video
//
//  Created by 李贤军 on 15/7/27.
//  Copyright (c) 2015年 TH. All rights reserved.
//

#import "DataBase.h"

@interface DataBase()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation DataBase
+ (instancetype)shareSQL
{
    static DataBase *dataBase = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dataBase = [[DataBase alloc] init];
    });
    return dataBase;
}


/**
 *  修改
 */
- (void)upDate:(videoModel *)model {
    
    // 固定写法
    [self.db beginTransaction];
    /**
     *  下面是修改两个数据
     */
    BOOL flag = [self.db executeUpdate:@"update t_contact set videoTime = ? where videoUrl = ?;", model.time, model.videoUrl];
    if (flag) {
        NSLog(@"update sucess");
    } else {
        NSLog(@"update failure");
        [self.db rollback];
    }
    
}


/**
 *  插入数据库
 */
-(void)insertDB:(videoModel *)model{
    //将获取的时间存入数据库
    //固定方法
    
    
    BOOL flag = [self.db executeUpdate:@"insert into t_contact(videoTime, videoUrl) values (?,?)",model.time,model.videoUrl ];
    
    if (flag) {
        NSLog(@"insert success");
    } else {
        NSLog(@"insert failure");
    }
    
    
    
}


//查询数据
-(NSArray *)selectFromDB{
    
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *result = [self.db executeQuery:@"select * from t_contact"];
    while ([result next]) {
        videoModel *model = [[videoModel alloc] init];
        //字段拿数据
        model.videoUrl = [result stringForColumn:@"videoUrl"];
        model.time = [result stringForColumn:@"videoTime"];
        [array addObject:model];
        NSLog(@"%@,%@",model.videoUrl,model.time);
        NSLog(@"%@",array);
    }
    
    return array;
}
/**
 *  创建数据库
 */
-(instancetype)init{
    self = [super init];
    if (self) {
        //获取沙盒路径
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        file = [file stringByAppendingPathComponent:@"contact.sqlite"];
        
        NSLog(@"%@",file);
        //创建数据库文件
        FMDatabase *db = [FMDatabase databaseWithPath:file];
        if ([db open]) {
            
            BOOL flag = [db executeUpdate:@"create table if not exists t_contact(id integer primary key autoincrement,videoTime text,videoUrl text);"];
            if (flag) {
                NSLog(@"创建成功");
            } else {
                NSLog(@"创建失败");
            }
        }
        self.db = db;
    }
    return self;
}
@end
