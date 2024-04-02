//
//  InProgressViewController.m
//  To-Do
//
//  Created by Hadir on 02/04/2024.
//

#import "InProgressViewController.h"
#import "NewTaskViewController.h"
#import "DetailsViewController.h"

@interface InProgressViewController ()

@property NewTaskViewController *addingTaskVC;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray<Task *> *allTasks;


@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addingTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewTaskViewController"];
    _allTasks = [NSMutableArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoingCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _allTasks[indexPath.row].name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allTasks.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detailsVC.task = _allTasks[indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [_allTasks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


- (void)addTask:(Task *)task {
    [_allTasks addObject: task];
    [_tableView reloadData];
}


@end
