//
//  BlackViewController.m
//  PickerView
//
//  Created by Alexey Bukhtin on 03.08.13.
//  Copyright (c) 2013 Cheapshot. All rights reserved.
//

#import "BlackViewController.h"
#import "LevelUpViewController.h"

@implementation BlackViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Black Picker";
        [self addNextBarButtonWithTitle:@"Level Up"];
    }
    return self;
}

- (UIViewController *)nextViewController
{
    return [LevelUpViewController new];
}

- (void)pickerView:(CSPickerView *)pickerView customizeTableView:(UITableView *)tableView
{
    if (tableView.tag != kCSPickerViewFrontTableTag) {
        tableView.backgroundColor = [UIColor blackColor];
    }
}

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row
{
    NSDate *someDate = [self dateAtRow:row];
    cell.textLabel.text = [self.dateFormatterShort stringFromDate:someDate];
    if (tableView.tag == kCSPickerViewFrontTableTag) {
        cell.detailTextLabel.text = [self.dateFormatterLong stringFromDate:someDate];
    }
}

@end
