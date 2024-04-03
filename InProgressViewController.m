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

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray<Task *> *allTasks;


@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _allTasks = [NSMutableArray new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self syncData];
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
        [self deleteTaskAtIndex:(int)indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


-(void) syncData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedTasks = [userDefaults objectForKey:@"doingTasks"];
    NSMutableArray<Task *> *existingTasks = [NSMutableArray new];
    
    if (encodedTasks != nil) {
        NSError *error = nil;
        existingTasks = [NSKeyedUnarchiver unarchiveObjectWithData: encodedTasks];
        _allTasks = existingTasks;
        [self.tableView reloadData];
    }
}

- (void)deleteTaskAtIndex:(int)index {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *encodedTasks = [userDefaults objectForKey:@"doingTasks"];
    NSMutableArray<Task *> *existingTasks = [NSMutableArray array];
    
    if (encodedTasks != nil) {
        NSError *error = nil;
        existingTasks = [NSKeyedUnarchiver unarchiveObjectWithData: encodedTasks];
    }
    
    if (index < existingTasks.count) {
        
        [existingTasks removeObjectAtIndex:index];
        
        NSError *error = nil;
        NSData *updatedEncodedTasks = [NSKeyedArchiver archivedDataWithRootObject:existingTasks];
        if (error != nil) {
            NSLog(@"Error archiving updated tasks: %@", error.localizedDescription);
            return;
        }
        [userDefaults setObject:updatedEncodedTasks forKey:@"doingTasks"];
        [userDefaults synchronize];
    } else {
        NSLog(@"Index is out of bounds.");
    }
    _allTasks = existingTasks;
}


@end
