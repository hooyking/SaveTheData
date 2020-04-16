//
//  UserDefaultsViewController.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "UserDefaultsViewController.h"
#import "PersonModel.h"

static NSString *const userDefaultKeyStr = @"userDefaultKey";
static NSString *const customerObjectKeyStr = @"customerObjectKey";

@interface UserDefaultsViewController ()

@end

@implementation UserDefaultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.showButton addTarget:self action:@selector(showButtonClicked) forControlEvents:UIControlEventTouchDown];
    [self.preserveButton addTarget:self action:@selector(preserveButtonClicked) forControlEvents:UIControlEventTouchDown];
}

//NSUserDefaults支持的数据类型有以下几种：

/*
 NSNumber（CGFloat、NSInteger、int、float、double）
 NSString（含NSMutableString）
 NSData（含NSMutableData）
 NSArray（含NSMutableArray）
 NSDictionary（含NSMutableDictionary
 BOOL
 */

//NSUserDefaults存储的对象全是不可变的，即使存进去的是可变的，取出来也是不可变的如NSMutableArray存进去，取出来就是NSArray了
//使用NSUserDefaults保存自定义类型，自定义类型必须遵循NSCoding协议，下面PersonModel有示例

- (void)showButtonClicked {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *text = [ud objectForKey:userDefaultKeyStr];
    self.label.text = text;
    
    NSData *data = [ud objectForKey:customerObjectKeyStr];
    PersonModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"名字：%@--年龄：%zd",model.name,model.age);
}

- (void)preserveButtonClicked {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.textField.text forKey:userDefaultKeyStr];
    
    PersonModel *model = [PersonModel new];
    model.name = @"张哈哈";
    model.age = 10;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [ud setObject:data forKey:customerObjectKeyStr];
    
    [ud synchronize];
}

@end

