//
//  AddressBookAddUserViewController.h
//  ScrollPage
//
//  Created by ios2 on 2019/3/25.
//  Copyright © 2019 LenSky. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddressBookAddUserViewController : UIViewController

//添加通讯录成功回调
@property (nonatomic,copy)void(^addUserSuccess)(void);


@end

