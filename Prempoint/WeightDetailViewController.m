//
//  WeightDetailViewController.m
//  Prempoint
//
//  Created by Niklas Ahola on 10/20/15.
//  Copyright © 2015 Yang. All rights reserved.
//

#import "WeightDetailViewController.h"
#import "WeightEntity+CoreDataProperties.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

#define API_KEY @"5f4e52833068f41bd9a7bc519eb278ff"

@interface WeightDetailViewController() <UITextFieldDelegate> {
    NSDateFormatter *_dateFormatter;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWeight;
@property (weak, nonatomic) IBOutlet UILabel *labelTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSave;
@property (weak, nonatomic) IBOutlet UIView *datePickerContainer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation WeightDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    
    if (self.weightObject) {
        _datePicker.date = self.weightObject.date;
        _textFieldDate.text = [_dateFormatter stringFromDate:self.weightObject.date];
        _textFieldWeight.text = [self.weightObject.weight stringValue];
        _labelTemp.text = [self.weightObject.temp stringValue];
        _labelDesc.text = self.weightObject.desc;
    }
    else {
        _datePicker.date = [NSDate date];
        [self fetchWeightInformation];
    }
}

- (void)fetchWeightInformation {
    
    CLLocation *userLocation = [AppDelegate getDelegate].userLocation;
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%.6f&lon=%.6f&appid=%@", userLocation.coordinate.latitude, userLocation.coordinate.longitude, API_KEY];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *weather = (NSDictionary *)responseObject;
        
        _labelTemp.text = [[[weather objectForKey:@"main"] objectForKey:@"temp"] stringValue];
        _labelDesc.text = [[[weather objectForKey:@"weather"] firstObject] objectForKey:@"description"];
        _textFieldDate.text = [_dateFormatter stringFromDate:_datePicker.date];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertController * alert =   [UIAlertController
                                      alertControllerWithTitle:@"Error Retrieving Weather"
                                      message:[error localizedDescription]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* btnOk = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
        
        [alert addAction:btnOk];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [operation start];
}

#pragma mark - show/hide date picker
- (void)showDatePicker:(BOOL)bShow {
    [self.view endEditing:YES];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect frame = _datePickerContainer.frame;
    frame.origin.y = bShow ? bounds.size.height - frame.size.height : bounds.size.height;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         _datePickerContainer.frame = frame;
                     }];
}

#pragma mark - button methods
- (IBAction)onSave:(id)sender {
    
    CGFloat weight = [_textFieldWeight.text floatValue];
    if (weight <= 0 || weight > 500) {
        UIAlertController * alert =   [UIAlertController
                                       alertControllerWithTitle:@"Error"
                                       message:@"Please enter valid weight (0 ~ 500)."
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* btnOk = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                }];
        
        [alert addAction:btnOk];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        if (self.weightObject == nil) {
            self.weightObject = [WeightEntity createWeightEntityObject];
        }
        self.weightObject.date = _datePicker.date;
        self.weightObject.weight = [NSNumber numberWithFloat:weight];
        self.weightObject.temp = [NSNumber numberWithFloat:[_labelTemp.text floatValue]];
        self.weightObject.desc = _labelDesc.text;
        [self.weightObject saveObject];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - textfield methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_textFieldDate]) {
        [self showDatePicker:YES];
        return NO;
    }
    else {
        [self showDatePicker:NO];
        return YES;
    }
}

- (IBAction)onDidEndOnExit:(id)sender {
    
}

#pragma mark - date picker methods
- (IBAction)onDatePickerValueChanged:(UIDatePicker*)datePicker {
    _textFieldDate.text = [_dateFormatter stringFromDate:_datePicker.date];
}

@end
