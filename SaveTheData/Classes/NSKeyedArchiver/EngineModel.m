//
//  EngineModel.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/17.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "EngineModel.h"

@implementation EngineModel

- (void)encodeWithCoder:(NSCoder *)coder {
    NSLog(@"EngineModel执行归档");
    [coder encodeObject:self.model forKey:@"model"];
    [coder encodeInteger:self.cylinderNumber forKey:@"cylinderNumber"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSLog(@"EngineModel执行解档");
    self = [super init];
    if (self) {
        self.model = [coder decodeObjectForKey:@"model"];
        self.cylinderNumber = [coder decodeIntegerForKey:@"cylinderNumber"];
    }
    return self;
}

@end
