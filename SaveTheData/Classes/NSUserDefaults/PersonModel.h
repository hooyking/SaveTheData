//
//  PersonModel.h
//  SaveTheData
//
//  Created by hooyking on 2020/4/16.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END
