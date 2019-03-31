//
//  AddressBookManager.m
//  ScrollPage
//
//  Created by ios2 on 2019/3/21.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import "AddressBookManager.h"
#import "BMChineseSort.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <AddressBookUI/AddressBookUI.h>
#endif

@implementation AddressBookManager
//请求认证
+(void)authorizationStatus:(void(^)(BOOL isSure))completion
{
	if (@available(iOS 9.0,*)) {
		CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
		if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
			[[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
				if (granted) {
					//用户同意
					if (completion) {
						completion(YES);
					}
				}else{
				}
			}];
		}else if (authorizationStatus == CNAuthorizationStatusDenied){
			//用户已经拒绝了
			UIAlertController *alete = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"我们希望您去设置开启通讯录权限使用此功能" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction * sureAction =  [UIAlertAction actionWithTitle:@"去开启" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			}];
			UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:nil];
			[alete addAction:sureAction];
			[alete addAction:cancelAction];
			[[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alete animated:YES completion:nil];
		}else if (authorizationStatus == CNAuthorizationStatusAuthorized) {
			if (completion) {
				completion(YES);
			}
		}

	} else {
		ABAuthorizationStatus bookStatus = ABAddressBookGetAuthorizationStatus();
		if (bookStatus == kABAuthorizationStatusNotDetermined) {
			ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
			ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
				if (granted) {
					NSLog(@"授权成功");
					if (completion) {
						completion(YES);
					}
				}
			});
			CFRelease(addressBook);
		}else if (bookStatus == kABAuthorizationStatusDenied) {
			//用户已经拒绝了
			UIAlertController *alete = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"我们希望您去设置开启通讯录权限使用此功能" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction * sureAction =  [UIAlertAction actionWithTitle:@"去开启" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			}];
			UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:nil];
			[alete addAction:sureAction];
			[alete addAction:cancelAction];
			[[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alete animated:YES completion:nil];
		}else if (bookStatus == kABAuthorizationStatusAuthorized) {
			if (completion) {
				completion(YES);
			}
		}
	}
}
//带有请求的认证
+(void)requestAddressBookInfos:(void(^)(NSArray *phoneInfos,NSArray *userNames))completion
{
	[self authorizationStatus:^(BOOL isSure) {
		if (isSure) {
			[self getAddressBookUserInfo:completion];
		}
	}];
}

+(void)getAddressBookUserInfo:(void(^)(NSArray *phoneInfos,NSArray *userNames))completion
{
	// ios 9.0 之后获取用户通讯录
	if(@available(iOS 9.0,*)){
		CNContactStore *store = [[CNContactStore alloc] init];
		NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
		CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
		NSError *error = nil;
		__block NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
		__block NSMutableArray *userNameArray = [NSMutableArray array];
		BOOL isSucess = [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
			PhoneUser *p = [[PhoneUser alloc]init];
			NSString *firstName = contact.givenName;
			NSString *lastName = contact.familyName;
				//NSLog(@"%@ %@", firstName, lastName);
			NSString *userName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
			p.userName = userName;
				// 4.2.获取电话号码
			NSMutableArray *phoneArray = [NSMutableArray array];
			NSArray *phones = contact.phoneNumbers;
			for (CNLabeledValue *labelValue in phones) {
					//			NSString *phoneLabel = labelValue.label;
				CNPhoneNumber *phoneNumber = labelValue.value;
				NSString *phoneValue = phoneNumber.stringValue;
				NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[_`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"];
				NSString *userPhone = [phoneValue stringByTrimmingCharactersInSet:set];
				userPhone = [userPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
				userPhone = [userPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
				[phoneArray addObject:userPhone];
			}
			p.userPhones = phoneArray;
			if ([p.userName isEqualToString:@""]) {
				p.userName = phoneArray.firstObject;
			}
			if (p.userPhones.count > 0) {
					//避免没有手机号造成的崩溃问题
				[userNameArray addObject:p.userName];
				[tmpArray addObject:p];
			}
		}];
		if (isSucess) {
			if (completion) {
				if (![NSThread isMainThread]) {
						//第一次授权成功是在异步线程中
					[[NSOperationQueue mainQueue] addOperationWithBlock:^{
						completion(tmpArray,userNameArray);
					}];
				}else{
					completion(tmpArray,userNameArray);
				}
			}
		}
	}else{
		[self getAddressBooksUser:completion];
	}
}
// ios 9.0 之前获取用户通讯录
+(void)getAddressBooksUser:(void(^)(NSArray *phoneInfos,NSArray *userNames))completion
{
		// 1. 获取通讯录引用
	NSMutableArray *temArray = [NSMutableArray array];
	NSMutableArray *userNameArray = [NSMutableArray array];
	ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
		// 2. 获取所有联系人记录
	NSArray *array = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBook));
	for (NSInteger i = 0; i < array.count; i++) {
		// 取出一条记录
		PhoneUser *p = [[PhoneUser alloc]init];
		ABRecordRef person = (__bridge ABRecordRef)(array[i]);
		ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
			// 取记录数量
		NSInteger phoneCount = ABMultiValueGetCount(phones);
		//找到电话号码
		NSMutableArray *phoneArray = [NSMutableArray array];
		for (int i = 0; i< phoneCount; i++) {
			NSString * phoneNumber =(__bridge NSString *) ABMultiValueCopyValueAtIndex(phones, i);
			NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[_`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]|\n|\r|\t"];
			NSString *userPhone = [phoneNumber stringByTrimmingCharactersInSet:set];
			userPhone = [userPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
			userPhone = [userPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
			[phoneArray addObject:userPhone];
		}
		p.userPhones = phoneArray;
		// 取出个人记录中的详细信息
		NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
		NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
		NSString *userName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
		p.userName = userName;
		if ([p.userName isEqualToString:@""]) {
			p.userName = phoneArray.firstObject;
		}
		if (p.userPhones.count > 0) {
			//避免没有手机号造成的崩溃问题
			[userNameArray addObject:p.userName];
			[temArray addObject:p];
		}
	}
	CFRelease(addressBook);
	if (completion) {
		if (![NSThread isMainThread]) {
			//第一次授权成功是在异步线程中
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				completion(temArray,userNameArray);
			}];
		}else{
			completion(temArray,userNameArray);
		}
	}
}

+(BOOL)cracteAddBookRecordBuPhoneArray:(NSArray<NSString *> *)phoneArr andTitle:(NSString *)title andNote:(NSString *)note
{
	__block BOOL isContaint = NO;
	[self requestAddressBookInfos:^(NSArray <PhoneUser *>* _Nonnull phoneInfos, NSArray * _Nonnull userNames) {
		[phoneInfos enumerateObjectsUsingBlock:^(PhoneUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[phoneArr enumerateObjectsUsingBlock:^(NSString * _Nonnull phoneStr, NSUInteger idx, BOOL * _Nonnull stop) {
				isContaint =  [obj.userPhones containsObject:phoneStr];
				if (isContaint) {
					*stop = YES;
				}
			}];
			if (isContaint) {
				*stop = YES;
			}
		}];
	}];
	//如果存在写入
	if (isContaint) {return YES;}
	if (@available(iOS 9.0, *)) {
		CNContactStore *addressBook = [[CNContactStore alloc] init];
		CNMutableContact *newRecord = [[CNMutableContact alloc] init];
		newRecord.familyName = title;
		__block NSMutableArray *phoneNumber = [NSMutableArray array];
		[phoneArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			CNPhoneNumber * number = [[CNPhoneNumber alloc]initWithStringValue:obj];
			CNLabeledValue *lable = [CNLabeledValue labeledValueWithLabel:nil value:number];
			[phoneNumber addObject:lable];
		}];
		newRecord.phoneNumbers = phoneNumber;
		newRecord.note = note;
		CNSaveRequest *request = [[CNSaveRequest alloc]init];
		[request addContact:newRecord toContainerWithIdentifier:nil];
		NSError *error = nil;
		[addressBook executeSaveRequest:request error:&error];
		if (error) {
			return NO;
		}else{
			return YES;
		}
	} else {
		return  [self createAddBookRecordByPhoneArr:phoneArr andTitle:title andNote:note];
	}
}

// 往通讯录添加一条新联系人
+ (BOOL)createAddBookRecordByPhoneArr:(NSArray *)phoneArr andTitle:(NSString *)title andNote:(NSString *)note{
	CFErrorRef error = NULL;
	if (!phoneArr || !title) {return NO;}

	ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
	ABRecordRef newRecord = ABPersonCreate();

	ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)title, &error);

		//创建一个多值属性(电话)
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		//    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)obj, (__bridge CFStringRef)@"亿点连接呼转测试", NULL);

	[phoneArr enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
			// 添加手机号码
		ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)phone, kABPersonPhoneMobileLabel, NULL);
	}];

	ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);

		//添加email
		//    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		//    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)([self.infoDic objectForKey:@"email"]), kABWorkLabel, NULL);
		//    ABRecordSetValue(newRecord, kABPersonEmailProperty, multiEmail, &error);

		// 添加备注
	ABRecordSetValue(newRecord, kABPersonNoteProperty, (__bridge CFTypeRef)note, &error);

		//添加记录到通讯录操作对象
	ABAddressBookAddRecord(addressBook, newRecord, &error);

		//保存通讯录操作对象
	ABAddressBookSave(addressBook, &error);

	CFRelease(multi);
	CFRelease(newRecord);
	CFRelease(addressBook);
	if (error) {
		return NO;
	}
	return YES;
}

@end


@implementation PhoneUser

-(void)setUserName:(NSString *)userName
{
	_userName = userName;
	if (![_userName isEqualToString:@""]) {
		NSString * pinyin =  [BMChineseSort transformChinese:_userName];
		if (pinyin!= nil && ![pinyin isEqualToString:@""]) {
			self.namepinyin = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
		}else{
			self.namepinyin = @"#";
		}
	}else{
		self.namepinyin = @"#";
	}
}
-(void)setUserPhones:(NSArray *)userPhones
{
	_userPhones = userPhones;
	if (_userPhones.firstObject) {
		_firstPhone = _userPhones.firstObject;
	}else{
		_firstPhone = @"";
	}
}

@end
