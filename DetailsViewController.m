//
//  DetailsViewController.m
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prioritySegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stateSegmentControl;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameTextField.text = _task.name;
    _descTextView.text = _task.desc;
    _prioritySegmentControl.selectedSegmentIndex = _task.priority;
    _stateSegmentControl.selectedSegmentIndex = _task.state;
    _dateLabel.text = _task.date;
}

- (IBAction)savePressed:(UIButton *)sender {
    NSString *key = [[NSString alloc] init];
    switch (_task.state) {
        case 0:
            key = @"toDoTasks";
            break;
        case 1:
            key = @"doingTasks";
            break;
        default:
            key = @"doneTasks";
            break;
    }
    [self updateTask:_task inArrayInUserDefaultsForKey:key];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)updateTask:(Task *)updatedTask inArrayInUserDefaultsForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedTasks = [userDefaults objectForKey:key];
    NSMutableArray<Task *> *existingTasks = [NSMutableArray array];
    
    if (encodedTasks != nil) {
        NSError *error = nil;
        existingTasks = [NSKeyedUnarchiver unarchiveObjectWithData: encodedTasks];
    }
    
    
    BOOL found = NO;
    for (NSInteger i = 0; i < existingTasks.count; i++) {
        Task *task = existingTasks[i];
        if ([task.uId isEqualToString:updatedTask.uId]) {
            existingTasks[i] = updatedTask;
            found = YES;
            break;
        }
    }
    
    if (!found) {
        NSLog(@"Task with ID %@ not found in array.", updatedTask.uId);
        return;
    }
    
  
    NSData *updatedEncodedTasks = [NSKeyedArchiver archivedDataWithRootObject:existingTasks];
  
    [userDefaults setObject:updatedEncodedTasks forKey:key];
    [userDefaults synchronize];
}



@end
