//
// CSPickerView.h
//
// Copyright (c) 2013 Cheapshot (http://cheapshot.co/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

extern NSInteger const kCSPickerViewBackTopTableTag;
extern NSInteger const kCSPickerViewBackBottomTableTag;
extern NSInteger const kCSPickerViewFrontTableTag;
extern NSString *const kCSPickerViewBackCellIdentifier;
extern NSString *const kCSPickerViewFrontCellIdentifier;

@protocol CSPickerViewDataSource, CSPickerViewDelegate;
@class CSPickerGradientView;

#pragma mark - Picker View

@interface CSPickerView : UIView

@property (nonatomic, weak) id <CSPickerViewDataSource> dataSource;
@property (nonatomic, weak) id <CSPickerViewDelegate> delegate;
@property (nonatomic) NSInteger selectedRow;
@property (nonatomic, readonly) CSPickerGradientView *gradientView;
@property (nonatomic) BOOL bounces;

- (void)reloadData;

- (void)setSelectedRow:(NSInteger)selectedRow animated:(BOOL)animated;

@end


#pragma mark - Picker View Data Source

@protocol CSPickerViewDataSource <NSObject>

@required
- (NSInteger)pickerView:(CSPickerView *)pickerView numberOfRowsInTableView:(UITableView *)tableView;
- (UITableViewCell *)pickerView:(CSPickerView *)pickerView tableView:(UITableView *)tableView cellForRow:(NSInteger)row;

@end

#pragma mark - Picker View Delegate

@protocol CSPickerViewDelegate <UITableViewDelegate>

@optional
- (void)pickerView:(CSPickerView *)pickerView customizeTableView:(UITableView *)tableView;
- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row;

@end


#pragma mark - Gradient View

@interface CSPickerGradientView : UIView

@property (nonatomic) NSArray *CGColors;
@property (nonatomic) NSArray *locations;

@end
