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
    switch (_stateSegmentControl.selectedSegmentIndex) {
        case 1:
            [_stateSegmentControl setEnabled: NO forSegmentAtIndex:0];
            break;
        case 2:
            [_stateSegmentControl setEnabled: NO forSegmentAtIndex:0];
            [_stateSegmentControl setEnabled: NO forSegmentAtIndex:1];
            break;
        default:
            break;
    }
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
    _task.name = _nameTextField.text;
    _task.desc = _descTextView.text;
    _task.priority = _prioritySegmentControl.selectedSegmentIndex;
    _task.state = _stateSegmentControl.selectedSegmentIndex;
    [self makeAlert: key];
    
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
            if(updatedTask.state != existingTasks[i].state){
                [existingTasks removeObjectAtIndex: i];
                [self updateTaskState: updatedTask];
            }
            else existingTasks[i] = updatedTask;
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

-(void) makeAlert: (NSString *)key{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are You Sure you want to edit!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateTask:self->_task inArrayInUserDefaultsForKey:key];
        [self.navigationController popViewControllerAnimated: YES];
    }];
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler: nil];
    [alert addAction:yesButton];
    [alert addAction: cancelButton];
    [self presentViewController: alert animated:YES completion:nil];
    
}

-(void) updateTaskState:(Task *) task{
    switch (task.state) {
        case 1:
            [self addTask:task toArrayInUserDefaultsForKey:@"doingTasks"];
            break;
        case 2:
            [self addTask:task toArrayInUserDefaultsForKey:@"doneTasks"];
            break;
        default:
            break;
    }

}

- (void)addTask:(Task *)newTask toArrayInUserDefaultsForKey:(NSString *)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedTasks = [userDefaults objectForKey:key];
    NSMutableArray<Task *> *existingTasks = [NSMutableArray new];
    
    if (encodedTasks != nil) {
        existingTasks = [NSKeyedUnarchiver unarchiveObjectWithData: encodedTasks];
        
    }
    if (existingTasks == (NSMutableArray *) nil) {
        existingTasks = [NSMutableArray new];
    }
    [existingTasks addObject: newTask];
    
    
    NSError *error = nil;
    
    NSData *updatedEncodedTasks = [NSKeyedArchiver archivedDataWithRootObject:existingTasks] ;
    
    if (error != nil) {
        NSLog(@"Error archiving updated tasks: %@", error.localizedDescription);
        return;
    }
    
    
    [userDefaults setObject:updatedEncodedTasks forKey:key];
    [userDefaults synchronize];
}


@end
