//
//  Car.h
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Car : NSObject <NSCoding>

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, strong) NSArray *wheelArr;

@end

NS_ASSUME_NONNULL_END
