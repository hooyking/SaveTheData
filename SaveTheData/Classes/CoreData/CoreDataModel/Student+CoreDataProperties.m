//
//  Student+CoreDataProperties.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/16.
//  Copyright © 2020 hooyking. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic age;
@dynamic name;
@dynamic sex;
@dynamic teachers;

@end
