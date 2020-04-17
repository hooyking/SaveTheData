//
//  CarModel.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

/*
 注意，若是此类的父类为自定义的，就必须在归档解档方法中加上[super encodeWithCoder:aCoder] 和 [super initWithCoder:aDecoder]方法;
 */

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSLog(@"CarModel执行归档");
    [aCoder encodeFloat:self.price forKey:@"price"];
    [aCoder encodeObject:self.brand forKey:@"brand"];
    [aCoder encodeObject:self.wheelArr forKey:@"wheelArr"];
    [aCoder encodeObject:self.engine forKey:@"engine"];
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"CarModel执行解档");
    self = [super init];
    if (self) {
        self.price = [aDecoder decodeFloatForKey:@"price"];
        self.brand = [aDecoder decodeObjectForKey:@"brand"];
        self.wheelArr = [aDecoder decodeObjectForKey:@"wheelArr"];
        self.engine = [aDecoder decodeObjectForKey:@"engine"];
    }
    return self;
}

@end
