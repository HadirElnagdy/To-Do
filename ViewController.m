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
@property NSMutableArray<Task *> *allTasks;
@property NewTaskViewController *addingTaskVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addingTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewTaskViewController"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _filteredTasks = [NSMutableArray new];
    _allTasks = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    _midPriority = [NSMutableArray new];
    _highPriority = [NSMutableArray new];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self syncData];
    
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


- (IBAction)searchTextChanged:(UITextField *)sender {
    if (sender.text.length > 0) {
        [self doSearch:sender.text];
    } else {
        [self filterTasks];
    }
}


- (IBAction)addTaskPressed:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:_addingTaskVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self deleteTask: _filteredTasks[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
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
        case 2:
            _filteredTasks = _lowPriority;
            break;
        default:
            _filteredTasks = _allTasks;
            break;
    }
    [_tableView reloadData];
}

-(void) syncData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedTasks = [userDefaults objectForKey:@"toDoTasks"];
    NSMutableArray<Task *> *existingTasks = [NSMutableArray new];
    
    if (encodedTasks != nil) {
        existingTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encodedTasks];
        
        
        [_highPriority removeAllObjects];
        [_midPriority removeAllObjects];
        [_lowPriority removeAllObjects];
        [_allTasks removeAllObjects];
        
        NSPredicate *highPriorityPredicate = [NSPredicate predicateWithFormat:@"priority == 0"];
        NSPredicate *midPriorityPredicate = [NSPredicate predicateWithFormat:@"priority == 1"];
        NSPredicate *lowPriorityPredicate = [NSPredicate predicateWithFormat:@"priority == 2"];
        
        _highPriority = [[existingTasks filteredArrayUsingPredicate:highPriorityPredicate] mutableCopy];
        _midPriority = [[existingTasks filteredArrayUsingPredicate:midPriorityPredicate] mutableCopy];
        _lowPriority = [[existingTasks filteredArrayUsingPredicate:lowPriorityPredicate] mutableCopy];
        _allTasks = [existingTasks mutableCopy];
        
        [self filterTasks];
    }
}

- (void)deleteTask:(Task *)task {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedTasks = [userDefaults objectForKey:@"toDoTasks"];
    NSMutableArray<Task *> *existingTasks = [NSMutableArray array];
    
    if (encodedTasks != nil) {
        NSError *error = nil;
        existingTasks = [NSKeyedUnarchiver unarchiveObjectWithData: encodedTasks];
    }
    
    BOOL found = NO;
    for (int i = 0; i < existingTasks.count; i++) {
        if ([existingTasks[i].uId isEqualToString:task.uId]) {
            [existingTasks removeObjectAtIndex:i];
            found = YES;
            break;
        }
    }
    
    if (!found) {
        NSLog(@"Task with ID %@ not found in array.", task.uId);
        return;
    }
    
    
    NSData *updatedEncodedTasks = [NSKeyedArchiver archivedDataWithRootObject:existingTasks];
    
    [userDefaults setObject:updatedEncodedTasks forKey:@"toDoTasks"];
    
    [self syncData];
}

-(void) doSearch: (NSString *)searchText{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    [_filteredTasks filterUsingPredicate: searchPredicate];
    [_tableView reloadData];
}


@end
