//
//  Editable.h
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@protocol Editable <NSObject>

-(void) addTask: (Task*)task;
-(void) editTask: (Task*) task;

@end

