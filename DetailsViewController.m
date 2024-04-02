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
    //delegate editTask(it will edit the task in the array and userdefaults
    [self.navigationController popViewControllerAnimated: YES];
}


@end
