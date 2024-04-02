//
//  NewTaskViewController.h
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import "ViewController.h"
#import "Editable.h"

@interface NewTaskViewController : ViewController

@property id<Editable> toDoDelegate;
@property id<Editable> doingDelegate;
@property id<Editable> doneDelegate;

@end

