//
//  RootViewController.m
//  PickerView
//
//  Created by Alexey Bukhtin on 03.08.13.
//  Copyright (c) 2013 Cheapshot. All rights reserved.
//

#import "RootViewController.h"
#import "BlackViewController.h"

@implementation RootViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"White Picker";
        [self addNextBarButtonWithTitle:@"Black"];
    }
    return self;
}

- (UIViewController *)nextViewController
{
    return [BlackViewController new];
}

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row
{
    NSDate *someDate = [self dateAtRow:row];
    cell.textLabel.text = [self.dateFormatterLong stringFromDate:someDate];
}

@end
