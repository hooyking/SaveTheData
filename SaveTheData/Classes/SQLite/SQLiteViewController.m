//
//  SQLiteViewController.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "SQLiteViewController.h"
#import <FMDB/FMDB.h>

@interface SQLiteViewController ()

@property (nonatomic,strong) FMDatabase *myDb;

@end

@implementation SQLiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"documentPath:%@",path);
    NSString *dbpath = [path stringByAppendingPathComponent:@"hooyking.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    self.myDb = db;
    
    //********************SQL创建表，增删改查都在下面，要用那个，取消那个注释就行*****************
    /**
     SQLite存储类型有以下几种
     NULL     NULL值
     REAL     浮点型（如CGFloat，float，double，不过都需要转成NSNumber存）
     INTEGER  整型（如NSInteger，int，不过都需要转成NSNumber存）
     TEXT     文本类（如NSString）
     BLOB     二进制（如图片、文件NSData）
     */
    
    //将documentPath复制进前往文件夹路径中，找一个像Datum - Lite这样的查看就行，好了，自己玩吧。
    //注意这个插入的数据那些都是对象哦，text对应NSString,blob对应NSData,integer对应NSNumber
    
    //创建表
    //[self createTable];
    
    //插入数据
    //[self insertData];
    
    //删除数据
    //[self deleteData];
    
    //修改数据(这个你要有数据可改哦,不然玩个蛋)
    //[self updateData];
    
    //查询数据
    //[self selectData];
    
    //建多张表与插入多个数据(这儿会涉及到线程安全,FMDatabase若是在并行队列中执行，由于它是无序的，就有可能出现失败的可能，因为几个线程抢夺资源，
    //但是FMDatabaseQueue就不会，它是有序的且在同一个线程执行，会按照程序顺序执行，就不会抢夺什么资源，全部都会成功)
    
    //这个方法插入数据不好弄，可看下边的moreQueue
//    [self moreOperate];
    [self moreQueue];
    
    //这儿顺便讲下对列的操作
    //[self operateColumn];
    
}

#pragma mark - 创建表;
- (void)createTable {
    if ([_myDb open]) {
        //这儿创建了一个列有 name|sex|age|nickname|phoneNum|nativePlace|photo 的名字为personTable的表
        BOOL result = [_myDb executeUpdate:@"create table if not exists personTable (name text, sex integer, age integer, nickname text, phoneNum text, nativePlace text, photo blob)"];
        if (result) {
            NSLog(@"创建表成功");
        }
        else {
            NSLog(@"创建表失败");
        }
        [_myDb close];
    }
}

#pragma mark - 增
- (void)insertData {
    if ([_myDb open]) {
        BOOL result = [_myDb executeUpdate:@"insert into personTable (name, sex, age, nickname, phoneNum, nativePlace, photo) values (?,?,?,?,?,?,?)",@"JDX",[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:18], @"hooyking", [NSNumber numberWithInteger:13888888888],@"sichuan",[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picture" ofType:@"jpg"]]];
        if (result) {
            NSLog(@"添加数据成功");
        }
        else {
            NSLog(@"添加数据失败");
        }
        [_myDb close];
    }
}

#pragma mark - 删
//删除分删除整张表的所有数据（即销毁表）与删除指定的数据，下面的方法可自己实验
- (void)deleteData {
    //删除这个表里nickname为hooyking的所有数据，列没有删除，依然存在
    if ([_myDb open]) {
        BOOL result = [_myDb executeUpdate:@"delete from personTable where nickname = ?",@"hooyking"];
        if (result) {
            NSLog(@"删除数据成功");
        }
        else {
            NSLog(@"删除数据失败");
        }
        [_myDb close];
    }
    //销毁这张表(即这个表删除后就不存在了)
//    if ([_myDb open]) {
//        BOOL result = [_myDb executeUpdate:@"drop table if exists personTable"];
//        if (result) {
//            NSLog(@"销毁表成功");
//        }
//        else {
//            NSLog(@"销毁表失败");
//        }
//        [_myDb close];
//    }
}

#pragma mark - 改
- (void)updateData {
    if ([_myDb open]) {
        BOOL result = [_myDb executeUpdate:@"update personTable set age = ? where nickname = ?",[NSNumber numberWithInteger:25],@"hooyking"];
        if (result) {
            NSLog(@"修改数据成功");
        }
        else {
            NSLog(@"修改数据失败");
        }
        [_myDb close];
    }
}

#pragma mark - 查
- (void)selectData {
    if ([_myDb open]) {
        //查询多条数据
        FMResultSet *res = [_myDb executeQuery:@"select name, age from personTable"];
        while ([res next]) {
            NSString *name = [res stringForColumn:@"name"];
            NSInteger age = [res intForColumn:@"age"];
            NSLog(@"姓名：%@----年龄：%ld",name,age);
        }
        
        //查询一条数据
        NSLog(@"年龄为25的人：%@",[_myDb stringForQuery:@"select name from personTable where age = ?",@25]);
        
        [_myDb close];
    }
}

#pragma mark - 建多张表，插入，查询多个数据等
- (void)moreOperate {
    if ([_myDb open]) {
        //创建表
        NSString *createSql = @"create table if not exists studentsTable1 (id integer, name text, sex integer);"
                               "create table if not exists studentsTable2 (id integer, name text, sex integer);"
                               "create table if not exists studentsTable3 (id integer, name text, sex integer);";
        BOOL createResult = [_myDb executeStatements:createSql];
        if (createResult) {
            NSLog(@"创建多张表成功");
        }
        else {
            NSLog(@"创建多张表失败");
        }
        //*********************************插入多条数据(这里涉及到线程安全)**************************************
        
        //**********************方法一*********************
        NSString *insertSql = @"insert into studentsTable1 (id, name, sex) values ('100', '张三', '1');"
                               "insert into studentsTable2 (id, name, sex) values ('200', '李四', '1');"
                               "insert into studentsTable3 (id, name, sex) values ('300', '如花', '0');";
        BOOL insertResult = [_myDb executeStatements:insertSql];
        if (insertResult) {
            NSLog(@"插入数据成功");
        }
        else {
            NSLog(@"插入数据失败");
        }
        
        //*********************方法二**********************
        //看这个方法：moreQueue
        
        
        //查询数据
        NSString *selectSql = @"select * from studentsTable1;"
                               "select * from studentsTable2;"
                               "select * from studentsTable3;";
        BOOL selectResult = [_myDb executeStatements:selectSql withResultBlock:^int(NSDictionary *dictionary) {
            NSLog(@"moreOperate查询到的结果:%@", [[dictionary allValues] componentsJoinedByString:@","]);
            return 0;
        }];
        if (selectResult) {
            NSLog(@"查询成功");
        }
        else {
            NSLog(@"查询失败");
        }
        [_myDb close];
    }
}

#pragma mark - 多个数据插入线程安全
- (void)moreQueue {
    //方法二里面线程安全又有两种方式，ok继续看
    if ([_myDb open]) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *dbpath = [path stringByAppendingPathComponent:@"hooyking.db"];
        FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        //第一种(一般就用这种就能保证线程安全了，那条数据有错，那么有错那条就不会插入进去,例如id改为i,自己看效果)
        [dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"insert into studentsTable1 (id, name, sex) values (?,?,?)",[NSNumber numberWithInteger:500], @"王五", [NSNumber numberWithInteger:1]];
            [db executeUpdate:@"insert into studentsTable2 (id, name, sex) values (?,?,?)",[NSNumber numberWithInteger:600], @"陆六", [NSNumber numberWithInteger:1]];
            [db executeUpdate:@"insert into studentsTable3 (id, name, sex) values (?,?,?)",[NSNumber numberWithInteger:700], @"史真香", [NSNumber numberWithInteger:0]];
        }];
        //第二种事务(当插入数据有错时，直接取消将插入的数据，可以改下列试试，例如id改为i,自己看效果)
//        [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//            BOOL res1 = [db executeUpdate:@"insert into studentsTable1 (id, name, sex) values (?,?,?)",[NSNumber numberWithInteger:500], @"王五", [NSNumber numberWithInteger:1]];
//            BOOL res2 = [db executeUpdate:@"insert into studentsTable2 (id, name, sex) values (?,?,?)",[NSNumber numberWithInteger:600], @"陆六", [NSNumber numberWithInteger:1]];
//            BOOL res3 = [db executeUpdate:@"insert into studentsTable3 (id, name, sex) values (?,?,?)",[NSNumber numberWithInteger:700], @"史真香", [NSNumber numberWithInteger:0]];
//            if (!res1 || !res2 || !res3) { //我这样写就是三条任何一条有错，这三条就一条都不插入,这个判断条件若是不写，那就会默认哪一条有错，那一条就不会加入，但是其他的正确的会插入
//                *rollback = YES;
//            }
//            [db executeUpdate:@"insert into studentsTable3 (id, name, sex) values (?,?,?)",[NSNumber numberWithInteger:800], @"你真溜", [NSNumber numberWithInteger:0]];
//        }];
    
        //查询数据
        NSString *selectSql = @"select * from studentsTable1;"
                               "select * from studentsTable2;"
                               "select * from studentsTable3;";
        BOOL selectResult = [_myDb executeStatements:selectSql withResultBlock:^int(NSDictionary *dictionary) {
            NSLog(@"moreQueue查询到的结果:%@", [[dictionary allValues] componentsJoinedByString:@","]);
            return 0;
        }];
        if (selectResult) {
            NSLog(@"查询成功");
        }
        else {
            NSLog(@"查询失败");
        }
        
        [_myDb close];
    }
}

#pragma mark - 对列的操作
- (void)operateColumn {
    if ([_myDb open]) {
        //这儿添加了添加名字为temp类型为text的列
        BOOL addColumnRes = [_myDb executeUpdate:@"alter table studentsTable1 add temp text"];
        if (addColumnRes) {
            NSLog(@"添加列成功");
        }
        else {
            NSLog(@"添加列失败");
        }
        
        //删除列
        //SQLite不支持alter对列进行修改与删除的方法来的，所以要删除列的替代方式为新建一个没有你要删除的列的表，
        //第一步：create table testTable(id integer, name text, sex integer);这个表没有列temp了，
        //第二步：insert into testTable select id, name, sex from studentsTable1;这儿完成了将表studentsTable1列id name sex中的全部数据插入到了表testTable中,
        //第三步：drop table if exists studentsTable1;删除原来的表studentsTable1,
        //第四步：alter table testTable rename to studentsTable1;将testTable重命名为studentsTable1,若是你要修改列名，方式和删除一样，可自己操作一下
        
        [_myDb executeStatements:@"select * from studentsTable1" withResultBlock:^int(NSDictionary *dictionary) {
            NSLog(@"对列操作后查询到的结果:%@", [[dictionary allValues] componentsJoinedByString:@","]);
            return 0;
        }];
        
        [_myDb close];
    }
}

@end
