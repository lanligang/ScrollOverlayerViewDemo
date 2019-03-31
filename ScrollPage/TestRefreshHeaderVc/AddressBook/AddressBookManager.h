//
//  AddressBookManager.h
//  ScrollPage
//
//  Created by ios2 on 2019/3/21.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <ContactsUI/ContactsUI.h>
#endif
@class PhoneUser;

@interface AddressBookManager : NSObject

//读取通讯录中的用户信息
+(void)requestAddressBookInfos:(void(^)(NSArray *phoneInfos,NSArray *userNames))completion;

//在通讯录中加人
/**
 * phoneArr 用户的手机号
 *title 用户名
 *note 备注
 * return 是否成功
 */
+(BOOL)cracteAddBookRecordBuPhoneArray:(NSArray<NSString *> *)phoneArr
							  andTitle:(NSString *)title
							   andNote:(NSString *)note;

@end

@interface PhoneUser : NSObject
//用户名称
@property (nonatomic,strong)NSString *userName;
//用户的手机号码
@property (nonatomic,strong)NSArray *userPhones;

@property (nonatomic,strong)NSString *firstPhone;

//用户的姓名拼音
@property (nonatomic,strong)NSString *namepinyin;

@end

