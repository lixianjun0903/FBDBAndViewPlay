//
//  DataBase.h
//  video
//
//  Created by 李贤军 on 15/7/27.
//  Copyright (c) 2015年 TH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "videoModel.h"
#import "FMDatabase.h"
@interface DataBase : NSObject
/**
 *  查询数据
 */
-(NSArray *)selectFromDB;
/**
 *  插入数据
 */
-(void)insertDB:(videoModel *)model;
/**
 *  修改
 */
- (void)upDate:(videoModel *)model;
/**
 *  打开数据库
 */
+ (instancetype)shareSQL;
@end
