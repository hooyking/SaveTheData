//
//  PersonModel.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/16.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}

@end
