//
//  SuperViewController.h
//  PickerView
//
//  Created by Alexey Bukhtin on 03.08.13.
//  Copyright (c) 2013 Cheapshot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperViewController : UIViewController <CSPickerViewDataSource, CSPickerViewDelegate>

@property (nonatomic) CSPickerView *pickerView;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *dateFormatterLong;
@property (nonatomic) NSDateFormatter *dateFormatterShort;

- (void)addNextBarButtonWithTitle:(NSString *)title viewController:(UIViewController *)viewController;

// For children view controllers.
- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row;

// For Data Source.
- (NSDate *)dateAtRow:(NSInteger)row;

@end
