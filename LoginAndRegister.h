//
//  LoginAndRegister.h
//  video
//
//  Created by 李李贤军 on 15/7/29.
//  Copyright (c) 2015年 TH. All rights reserved.
//

#import "AFAppRequest.h"

@interface LoginAndRegister : AFAppRequest
+(AFRequestState *)loginWithSucc:(void(^)(NSDictionary * DataDic))succ WithUserName:(NSString *)userName WithPassword:(NSString *)password;
+(AFRequestState *)registerWithSucc:(void(^)(NSDictionary * DataDic))succ WithUserName:(NSString *)userName WithPassword:(NSString *)password WithUserType:(int)userType WithSource:(int)source WithPhoneNum:(NSString *)phoneNum WithEmail:(NSString *)email;
@end
