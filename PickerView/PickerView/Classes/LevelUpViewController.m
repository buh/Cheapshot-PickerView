//
//  LevelUpViewController.m
//  PickerView
//
//  Created by Alexey Bukhtin on 04.08.13.
//  Copyright (c) 2013 Cheapshot. All rights reserved.
//

#import "LevelUpViewController.h"

static NSInteger const kLevelUpViewControllerCount = 6;

@interface LevelUpViewController ()
@property (nonatomic) CSPickerView *pickerView2;
@property (nonatomic) BOOL pickerViewLocked;
@property (nonatomic) UILabel *levelUpLabel;
@end

@implementation LevelUpViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Level Up!";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    [self setupLabel];
    
    _pickerView2 = [[CSPickerView alloc] initWithFrame:CGRectZero];
    _pickerView2.delegate = self;
    _pickerView2.dataSource = self;
    [self.view addSubview:_pickerView2];
    
    self.pickerView.selectedRow = 3;
    _pickerView2.selectedRow = 2;
}

- (void)setupLabel
{
    _levelUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 60.f, self.view.frame.size.width, 30.f)];
    _levelUpLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f];
    _levelUpLabel.backgroundColor = [UIColor clearColor];
    _levelUpLabel.textColor = [UIColor whiteColor];
    _levelUpLabel.text = @"Distribute 5 skill points:";
    _levelUpLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_levelUpLabel];
}

- (void)viewDidLayoutSubviews
{
//    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    frame.size.height = 220.f;
    frame.size.width = 159.f;
    frame.origin.y = 100.f;
    self.pickerView.frame = frame;
    frame.origin.x = 161.f;
    _pickerView2.frame = frame;
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
    cell.textLabel.text = (tableView.tag == kCSPickerViewFrontTableTag
                           ? [NSString stringWithFormat:@"+%i %@", row, (pickerView == _pickerView2 ? @"Stamina" : @"Agility")]
                           : [NSString stringWithFormat:@"+%i", row]);
    
}

- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row
{
    if (!_pickerViewLocked) {
        _pickerViewLocked = YES;
        CSPickerView *pickerView2 = pickerView == _pickerView2 ? self.pickerView : _pickerView2;
        [pickerView2 setSelectedRow:((kLevelUpViewControllerCount - 1) - row) animated:YES];
    }
    _pickerViewLocked = NO;
}

- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView
{
    return kLevelUpViewControllerCount;
}

@end
