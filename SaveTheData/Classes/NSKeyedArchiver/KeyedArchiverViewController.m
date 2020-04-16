//
//  KeyedArchiverViewController.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "KeyedArchiverViewController.h"
#import "Car.h"

@interface KeyedArchiverViewController ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation KeyedArchiverViewController

/*
 只要遵循了NSCoding协议，都可以实现序列化
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = @"归档后方可解档";
    self.textField.hidden = YES;
    [self.preserveButton setTitle:@"归档" forState:UIControlStateNormal];
    [self.showButton setTitle:@"解档" forState:UIControlStateNormal];
    
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    self.filePath = [docuPath stringByAppendingPathComponent:@"car.data"];
    NSLog(@"归档文件路径：%@",docuPath);
    [self.showButton addTarget:self action:@selector(showButtonClicked) forControlEvents:UIControlEventTouchDown];
    [self.preserveButton addTarget:self action:@selector(preserveButtonClicked) forControlEvents:UIControlEventTouchDown];
}

- (void)showButtonClicked {
    Car *car = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    NSLog(@"--车价格：%.2f--车标：%@--车轮子：%@,%@,%@,%@",car.price,car.brand,car.wheelArr[0],car.wheelArr[1],car.wheelArr[2],car.wheelArr[3]);
}

- (void)preserveButtonClicked {
    Car *car = [[Car alloc] init];
    car.price = 50000000;
    car.brand = @"布加迪威龙";
    car.wheelArr = @[@"左前轮",@"右前轮",@"左后轮",@"右后轮"];
    [NSKeyedArchiver archiveRootObject:car toFile:self.filePath];
}

@end
