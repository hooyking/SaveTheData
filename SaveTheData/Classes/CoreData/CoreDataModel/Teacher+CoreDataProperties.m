//
//  Teacher+CoreDataProperties.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/16.
//  Copyright © 2020 hooyking. All rights reserved.
//
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
}

@dynamic age;
@dynamic name;
@dynamic students;

@end
