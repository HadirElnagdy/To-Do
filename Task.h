//
//  Task.h
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import <Foundation/Foundation.h>


@interface Task : NSObject

@property NSString *name;
@property NSString *desc;
@property NSString *date;
@property long priority;
@property long state;


@end

