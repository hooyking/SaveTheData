//
//  Car.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "Car.h"

@implementation Car

/*
 注意，若是此类的父类为自定义的，就必须在归档解档方法中加上[super encodeWithCoder:aCoder] 和 [super initWithCoder:aDecoder]方法;
 */

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSLog(@"执行归档");
    [aCoder encodeFloat:self.price forKey:@"price"];
    [aCoder encodeObject:self.brand forKey:@"brand"];
    [aCoder encodeObject:self.wheelArr forKey:@"wheelArr"];
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"执行解档");
    self = [super init];
    if (self) {
        self.price = [aDecoder decodeFloatForKey:@"price"];
        self.brand = [aDecoder decodeObjectForKey:@"brand"];
        self.wheelArr = [aDecoder decodeObjectForKey:@"wheelArr"];
    }
    return self;
}

@end
