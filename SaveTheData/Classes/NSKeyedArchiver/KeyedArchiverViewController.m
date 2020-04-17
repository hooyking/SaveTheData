//
//  KeyedArchiverViewController.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "KeyedArchiverViewController.h"
#import "CarModel.h"
#import "EngineModel.h"

@interface KeyedArchiverViewController ()

@property (nonatomic, copy) NSString *singleCommonFilePath;
@property (nonatomic, copy) NSString *multipleCommonFilePath;
@property (nonatomic, copy) NSString *customerModelFilePath;

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
    NSLog(@"归档文件路径：%@",docuPath);
    //这里的后缀名用了.data,实际上用什么后缀名都无所谓的。
    self.singleCommonFilePath = [docuPath stringByAppendingPathComponent:@"singleCommon.data"];
    self.multipleCommonFilePath = [docuPath stringByAppendingPathComponent:@"multipleCommon.data"];
    self.customerModelFilePath = [docuPath stringByAppendingPathComponent:@"car.data"];
    [self.showButton addTarget:self action:@selector(showButtonClicked) forControlEvents:UIControlEventTouchDown];
    [self.preserveButton addTarget:self action:@selector(preserveButtonClicked) forControlEvents:UIControlEventTouchDown];
}

- (void)showButtonClicked {
    //单个普通数据的解档
    NSString *singleString = [NSKeyedUnarchiver unarchiveObjectWithFile:self.singleCommonFilePath];
    NSLog(@"单个普通数据的解档：%@",singleString);
    
    //多个普通数据的解档
    NSMutableData *mutableData = [NSMutableData dataWithContentsOfFile:self.multipleCommonFilePath];
    NSKeyedUnarchiver *keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:mutableData];
    NSInteger age = [keyedUnarchiver decodeIntegerForKey:@"age"];
    NSString *name = [keyedUnarchiver decodeObjectForKey:@"name"];
    NSArray *toies = [keyedUnarchiver decodeObjectForKey:@"toies"];
    [keyedUnarchiver finishDecoding];
    NSLog(@"多个普通数据的解档：年龄：%zd--名字：%@--玩具：%@,%@,%@",age,name,toies[0],toies[1],toies[2]);
    
    //自定义对象的解档
    CarModel *car = [NSKeyedUnarchiver unarchiveObjectWithFile:self.customerModelFilePath];
    NSLog(@"自定义对象的解档：车价格：%.2f--车标：%@--车轮子：%@,%@,%@,%@--发动机型号：%@--发动机气缸数：%zd",
          car.price,car.brand,car.wheelArr[0],car.wheelArr[1],car.wheelArr[2],car.wheelArr[3],car.engine.model,car.engine.cylinderNumber);
}

- (void)preserveButtonClicked {
    //单个普通数据的归档
    NSString *singleString = @"单个普通数据的归档看看如何？";
    BOOL singleSuccess = [NSKeyedArchiver archiveRootObject:singleString toFile:self.singleCommonFilePath];
    if (singleSuccess) {
        NSLog(@"单个普通数据归档成功");
    } else {
        NSLog(@"单个普通数据归档失败");
    }
    
    //多个普通数据的归档
    NSInteger age = 20;
    NSString *name = @"张三";
    NSArray *toies = @[@"柯尼赛格",@"百达斐丽",@"陆家嘴100套房"];
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    NSKeyedArchiver *multipleKeyArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [multipleKeyArchiver encodeInteger:age forKey:@"age"];
    [multipleKeyArchiver encodeObject:name forKey:@"name"];
    [multipleKeyArchiver encodeObject:toies forKey:@"toies"];
    [multipleKeyArchiver finishEncoding];//完成归档
    BOOL multipleSuccess = [mutableData writeToFile:self.multipleCommonFilePath atomically:YES];//写入文件
    if (multipleSuccess) {
        NSLog(@"多个普通数据归档成功");
    } else {
        NSLog(@"多个普通数据归档失败");
    }
    
    //自定义对象的归档
    CarModel *car = [[CarModel alloc] init];
    car.price = 50000000;
    car.brand = @"布加迪威龙";
    car.wheelArr = @[@"左前轮",@"右前轮",@"左后轮",@"右后轮"];
    
    EngineModel *engine = [[EngineModel alloc] init];
    engine.model = @"无敌旋风";
    engine.cylinderNumber = 100;
    
    car.engine = engine;
    
    //对于自定义对象，不论他是只保存这个对象还是对象的array,dictionary,set，只要此对象遵循了NSCoding协议，都可进行归档
    BOOL success = [NSKeyedArchiver archiveRootObject:car toFile:self.customerModelFilePath];
    if (success) {
        NSLog(@"自定义对象归档成功");
    } else {
        NSLog(@"自定义对象归档失败");
    }
}

@end
