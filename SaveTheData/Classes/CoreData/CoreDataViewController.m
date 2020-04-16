//
//  CoreDataViewController.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "CoreDataViewController.h"
#import <CoreData/CoreData.h>
#import "Student+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"

static NSString *const kCoreDataCellId = @"HKCoreDataCell";

#define kScreenH  [UIScreen mainScreen].bounds.size.height
#define kScreenW  [UIScreen mainScreen].bounds.size.width

@interface CoreDataViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *dataMArray;

@end

@implementation CoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 60;
    self.dataMArray = [NSMutableArray array];
    [self createCoreDataLite];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCoreDataCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCoreDataCellId];
    }
    Teacher *model = self.dataMArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"老师名：%@--老师年龄：%hd",model.name,model.age];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    vi.backgroundColor = [UIColor whiteColor];
    
    NSArray *buttonTitleArray = @[@"插入",@"删除",@"更新",@"查询"];
    for (int i = 0; i< 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i*70, 0, 50, 40);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [vi addSubview:button];
    }
    
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - 增删改查
- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            [self insertData];
            break;
        case 101:
            [self deleteData];
        break;
        case 102:
            [self updateData];
        break;
        case 103:
            [self findData];
        break;
            
        default:
            break;
    }
}

//如果已添加此数据库，就算再次调用也不用重复添加,查看数据库可下载个Datum - Lite，CoreData说到底就是苹果对SQLite数据库的封装
#pragma mark - 创建CoreData数据库
- (void)createCoreDataLite {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];//CoreData为你自定义的CoreData文件名，momd为固定的类型
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"coreData.sqlite"];
    NSLog(@"数据库地址%@",path);
    NSURL *sqlURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlURL options:nil error:&error];
    if (error) {
        NSLog(@"错误%@",error);
    } else {
        NSLog(@"创建数据库成功,如果已添加此数据库，就算再次调用也不用重复添加，直接使用以前的");
    }
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = store;
    self.context = context;
}

#pragma mark - 添加数据
- (void)insertData {
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
    student.name = [NSString stringWithFormat:@"Student%d",arc4random()%100];
    student.age = arc4random()%20;
    student.sex = arc4random()%2 == 0 ?  @"女" : @"男";

    Teacher *teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.context];
    teacher.name = [NSString stringWithFormat:@"Teacher%d",arc4random()%100];
    teacher.age = arc4random()%60;
    teacher.students = [NSSet setWithArray:@[student]];
    
    NSError *error = nil;
    if ([self.context save:&error]) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

/** ******************对数据的改动都要调用NSManagerObjectContent的save方法**************** */

#pragma mark - 删除数据
- (void)deleteData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < 50"];
    request.predicate = predicate;
    NSArray *deleteArray = [self.context executeFetchRequest:request error:nil];
    for (Teacher *model in deleteArray) {
        NSLog(@"老师的学生%@",model.students);
        [self.context deleteObject:model];
    }
    NSError *error = nil;
    if ([self.context save:&error]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败%@",error);
    }
}

#pragma mark - 更新数据
- (void)updateData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < 45"];
    request.predicate = predicate;
    NSArray *updateArray = [self.context executeFetchRequest:request error:nil];
    for (Teacher *model in updateArray) {
        model.name = @"张三";
    }
    NSError *error = nil;
    if ([self.context save:&error]) {
        NSLog(@"更新成功");
    } else {
        NSLog(@"更新失败");
    }
}

#pragma mark - 查询数据
- (void)findData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    //此处可写查询条件
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < 50"];
//    request.predicate = predicate;
    //此处可写排序条件(这儿按年龄排序)
//    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"ascending:YES];
//    request.sortDescriptors = @[ageSort];
    NSArray *resultArray = [self.context executeFetchRequest:request error:nil];
    self.dataMArray = [resultArray mutableCopy];
    [self.tableView reloadData];
}


@end

