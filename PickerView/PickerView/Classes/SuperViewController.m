//
//  SuperViewController.m
//  PickerView
//
//  Created by Alexey Bukhtin on 03.08.13.
//  Copyright (c) 2013 Cheapshot. All rights reserved.
//

#import "SuperViewController.h"

static NSInteger const kSuperViewControllerCount = 30;

@interface SuperViewController ()
@property (nonatomic) UIViewController *nextViewController;
@end

@implementation SuperViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        // Setup Date Formatters.
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        
        _dateFormatterLong = [NSDateFormatter new];
        [_dateFormatterLong setDateStyle:NSDateFormatterLongStyle];
        [_dateFormatterLong setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatterLong setLocale:[NSLocale currentLocale]];
        
        _dateFormatterShort = [NSDateFormatter new];
        [_dateFormatterShort setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatterShort setTimeStyle:NSDateFormatterNoStyle];
        [_dateFormatterShort setLocale:[NSLocale currentLocale]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _pickerView = [[CSPickerView alloc] initWithFrame:self.view.bounds];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self.view addSubview:_pickerView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _pickerView.frame = self.view.bounds;
}

#pragma mark - Picker Delegate and Data Source

- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSDate *date = [self dateAtRow:row];
    self.title = [_dateFormatter stringFromDate:date];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == kCSPickerViewFrontTableTag ? 60.f : 30.f;
}

- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView
{
    return kSuperViewControllerCount;
}

- (UITableViewCell *)pickerView:(CSPickerView *)pickerView tableView:(UITableView *)tableView cellForRow:(NSInteger)row
{
    // Create table cell.
    NSString *identifier = (tableView.tag == kCSPickerViewFrontTableTag
                            ? kCSPickerViewFrontCellIdentifier : kCSPickerViewBackCellIdentifier);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (tableView.tag == kCSPickerViewBackTableTag) {
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f];
        } else {
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.f];
        }
    }
    
    // Populate table cell.
    [self pickerView:pickerView tableView:tableView populateCell:cell atRow:row];
    
    return cell;
}

- (void)pickerView:(CSPickerView *)pickerView
         tableView:(UITableView *)tableView
      populateCell:(UITableViewCell *)cell
             atRow:(NSInteger)row
{} // For children view controllers.

- (NSDate *)dateAtRow:(NSInteger)row
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = row;
    NSDate *someDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    return someDate;
}

#pragma mark - Navigation

- (void)addNextBarButtonWithTitle:(NSString *)title viewController:(UIViewController *)viewController
{
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(next)];
    self.navigationItem.rightBarButtonItem = nextBarButton;
    _nextViewController = viewController;
}

- (void)next
{
    [self.navigationController pushViewController:_nextViewController animated:YES];
}

@end
