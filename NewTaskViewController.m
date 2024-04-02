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
    task.name = _nameTextField.text;
    task.desc = _descTextView.text;
    task.priority = _prioritySegmentControl.selectedSegmentIndex;
    task.state = _stateSegmentControl.selectedSegmentIndex;
    task.date = [self getDate];
    switch (_stateSegmentControl.selectedSegmentIndex) {
        case 0:
            [self->_toDoDelegate addTask: task];
            break;
        case 1:
            [self->_doingDelegate addTask: task];
            break;
        default:
            [self->_doneDelegate addTask: task];
            break;
    }
    [self clear];
    [self dismissViewControllerAnimated:YES completion: nil];
    
}
- (IBAction)cancelPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion: nil];
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

@end
