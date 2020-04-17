//
//  CarModel.h
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EngineModel.h"

NS_ASSUME_NONNULL_BEGIN

//@class EngineModel;

@interface CarModel : NSObject <NSCoding>

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, strong) NSArray *wheelArr;
@property (nonatomic, strong) EngineModel *engine;

@end

NS_ASSUME_NONNULL_END
