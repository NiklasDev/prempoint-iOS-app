//
//  ViewController.m
//  Prempoint
//
//  Created by Niklas Ahola on 10/20/15.
//  Copyright © 2015 Yang. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "WeightEntity.h"
#import "WeightDetailViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSDate *_dateFrom;
    NSDate *_dateTo;
    UITextField *_selectedTextField;
    NSDateFormatter *_dateFormatter;
    NSInteger _selectedIndex;
}

@property (strong, nonatomic) NSMutableArray *weightObjects;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFrom;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *datePickerContainer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    self.weightObjects = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadWeightOjbects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWeightOjbects {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.weightObjects removeAllObjects];
        [self.weightObjects addObjectsFromArray:[WeightEntity loadWeightObjects:_dateFrom to:_dateTo]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - internal methods
- (void)updateDateFields {
    if (_dateFrom) {
        [_textFieldFrom setText:[_dateFormatter stringFromDate:_dateFrom]];
    }
    if (_dateTo) {
        [_textFieldTo setText:[_dateFormatter stringFromDate:_dateTo]];
    }
}

- (void)actionGotoDetails {
    [self performSegueWithIdentifier:@"WeightDetailSegue" sender:nil];
}

#pragma mark - button handler
- (IBAction)onBtnFilter:(id)sender {
    [self showDatePicker:NO];
    [self loadWeightOjbects];
}

- (IBAction)onBtnAddNew:(id)sender {
    _selectedIndex = -1;
    [self actionGotoDetails];
}

#pragma mark - show/hide date picker
- (void)showDatePicker:(BOOL)bShow {
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect frame = _datePickerContainer.frame;
    frame.origin.y = bShow ? bounds.size.height - frame.size.height : bounds.size.height;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         _datePickerContainer.frame = frame;
                     }];
}

#pragma mark - table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.weightObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"WeightCellIdentiifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *labelDate = (UILabel*)[cell viewWithTag:100];
    UILabel *labelWeight = (UILabel*)[cell viewWithTag:200];
    UILabel *labelTemp = (UILabel*)[cell viewWithTag:300];
    UILabel *labelDesc = (UILabel*)[cell viewWithTag:400];
    
    WeightEntity *weightObject = [self.weightObjects objectAtIndex:indexPath.row];
    
    labelDate.text = [_dateFormatter stringFromDate:weightObject.date];
    labelWeight.text = [NSString stringWithFormat:@"%.2f kg", [weightObject.weight floatValue]];
    labelTemp.text = [NSString stringWithFormat:@"%.2f F", [weightObject.temp floatValue]];
    labelDesc.text = weightObject.desc;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self actionGotoDetails];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WeightEntity *object = [self.weightObjects objectAtIndex:indexPath.row];
        [object deleteObject];
        [self.weightObjects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - text field methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _selectedTextField = textField;
    if ([textField isEqual:_textFieldFrom]) {
        _datePicker.date = _dateFrom ? _dateFrom : [NSDate date];
    }
    else if ([textField isEqual:_textFieldTo]) {
        _datePicker.date = _dateTo ? _dateTo : [NSDate date];
    }
    [self showDatePicker:YES];
    return NO;
}

- (IBAction)onDidEndOnExit:(id)sender {
    
}

#pragma mark - date picker methods
- (IBAction)onDatePickerValueChanged:(UIDatePicker*)datePicker {
    if ([_selectedTextField isEqual:_textFieldFrom]) {
        _dateFrom = datePicker.date;
    }
    else if ([_selectedTextField isEqual:_textFieldTo]) {
        _dateTo = datePicker.date;
    }
    [self updateDateFields];
}

#pragma mark -
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (_selectedIndex > -1) {
        WeightDetailViewController *viewController = (WeightDetailViewController*)segue.destinationViewController;
        WeightEntity *object = [self.weightObjects objectAtIndex:_selectedIndex];
        viewController.weightObject = object;
    }
}

@end
