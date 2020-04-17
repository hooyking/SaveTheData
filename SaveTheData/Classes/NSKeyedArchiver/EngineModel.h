//
//  EngineModel.h
//  SaveTheData
//
//  Created by hooyking on 2020/4/17.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EngineModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *model;
@property (nonatomic, assign) NSInteger cylinderNumber;

@end

NS_ASSUME_NONNULL_END
