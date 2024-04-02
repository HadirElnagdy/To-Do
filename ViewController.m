//
//  ViewController.m
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import "ViewController.h"
#import "NewTaskViewController.h"
#import "DetailsViewController.h"
#import "Task.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property NSMutableArray<Task *> *highPriority;
@property NSMutableArray<Task *> *lowPriority;
@property NSMutableArray<Task *> *midPriority;
@property NSMutableArray<Task *> *filteredTasks;
@property NewTaskViewController *addingTaskVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addingTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewTaskViewController"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _filteredTasks = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    _midPriority = [NSMutableArray new];
    _highPriority = [NSMutableArray new];
    [self filterTasks];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _filteredTasks[indexPath.row].name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return _filteredTasks.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detailsVC.task = _filteredTasks[indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
}


- (IBAction)addTaskPressed:(UIBarButtonItem *)sender {
    [self presentViewController: _addingTaskVC animated: YES completion: ^(void){
        self->_addingTaskVC.toDoDelegate = self;
    }];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self deleteFromList: (int)indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


- (void)addTask:(Task *)task { 
    switch (task.priority) {
        case 0:
            [_highPriority addObject: task];
            _filteredTasks = _highPriority;
            break;
        case 1:
            [_midPriority addObject: task];
            _filteredTasks = _midPriority;
            break;
        default:
            [_lowPriority addObject: task];
            _filteredTasks = _lowPriority;
            break;
    }
    [self filterTasks];
    [_tableView reloadData];
}

- (void)editTask:(Task *)task { 
    //
}


- (IBAction)priorityFilterChanged:(UISegmentedControl *)sender {
    [self filterTasks];
}

-(void) filterTasks{
    switch (_prioritySegmentedControl.selectedSegmentIndex) {
        case 0:
            _filteredTasks = _highPriority;
            break;
        case 1:
            _filteredTasks = _midPriority;
            break;
        default:
            _filteredTasks = _lowPriority;
            break;
    }
    [_tableView reloadData];
}

-(void) deleteFromList: (int) index{
    switch (_prioritySegmentedControl.selectedSegmentIndex) {
        case 0:
            [_highPriority removeObjectAtIndex: index];
            _filteredTasks = _highPriority;
            break;
        case 1:
            [_midPriority  removeObjectAtIndex: index];
            _filteredTasks = _midPriority;
            break;
        default:
            [_lowPriority  removeObjectAtIndex: index];
            _filteredTasks = _lowPriority;
            break;
    }
}



@end
