//
//  PlistViewController.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "PlistViewController.h"

@interface PlistViewController ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation PlistViewController

/*可被序列化的只有以下几种类型*/

/*
 NSString（含NSMutableString）
 NSArray（含NSMutableArray）
 NSDictionary（含NSMutableDictionary）
 NSData（含 NSMutableData）
 NSNumber
 NSDate
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    self.filePath = [docuPath stringByAppendingPathComponent:@"hooyking.plist"];
    NSLog(@"Plist文件路径：%@",docuPath);
    [self.showButton addTarget:self action:@selector(showButtonClicked) forControlEvents:UIControlEventTouchDown];
    [self.preserveButton addTarget:self action:@selector(preserveButtonClicked) forControlEvents:UIControlEventTouchDown];
}

- (void)showButtonClicked {
    NSError *error = nil;
    self.label.text = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:&error];
    
    //也可以在项目中新建一个plist文件，然后保存在plist文件
    NSString *customerPlistPath = [[NSBundle mainBundle] pathForResource:@"HK" ofType:@"plist"];
    NSArray *customerPlistArray = [NSArray arrayWithContentsOfFile:customerPlistPath];
    NSLog(@"项目中新建的plist文件保存的数据%@",customerPlistArray);
}

- (void)preserveButtonClicked {
    NSError *error = nil;
    [self.textField.text writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    //也可以在项目中新建一个plist文件，然后保存在plist文件
    NSString *customerPlistPath = [[NSBundle mainBundle] pathForResource:@"HK" ofType:@"plist"];
    NSArray *nameArray = @[@"first",@"last"];
    [nameArray writeToFile:customerPlistPath atomically:YES];
}

@end

