//
//  NewTaskViewController.m
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import "NewTaskViewController.h"
#import "Task.h"

@interface NewTaskViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prioritySegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stateSegmentControl;


@end

@implementation NewTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)donePressed:(UIButton *)sender {
    Task *task = [Task new];
    task.uId = [self generateUUID];
    task.name = _nameTextField.text;
    task.desc = _descTextView.text;
    task.priority = _prioritySegmentControl.selectedSegmentIndex;
    task.state = _stateSegmentControl.selectedSegmentIndex;
    task.date = [self getDate];
    switch (_stateSegmentControl.selectedSegmentIndex) {
        case 0:
            [self addTask:task toArrayInUserDefaultsForKey:@"toDoTasks"];
            break;
        case 1:
            [self addTask:task toArrayInUserDefaultsForKey:@"doingTasks"];
            break;
        default:
            [self addTask:task toArrayInUserDefaultsForKey:@"doneTasks"];
            break;
    }
    [self clear];
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(NSString*) getDate{
    
    NSDate *date= [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return  dateString;
}

-(void) clear{
    _nameTextField.text = @"";
    _descTextView.text = @"";
    _prioritySegmentControl.selectedSegmentIndex = 0;
    _stateSegmentControl.selectedSegmentIndex = 0;
}

-(NSString *)generateUUID{
    return [[NSUUID UUID] UUIDString];
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
