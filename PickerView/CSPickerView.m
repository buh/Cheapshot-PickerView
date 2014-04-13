//
// CSPickerView.m
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

#import <QuartzCore/QuartzCore.h>
#import "CSPickerView.h"

NSInteger const kCSPickerViewFrontTableTag = 10001;
NSInteger const kCSPickerViewBackTopTableTag = 10002;
NSInteger const kCSPickerViewBackBottomTableTag = 10003;
NSString *const kCSPickerViewBackCellIdentifier = @"kCSPickerViewBackCellIdentifier";
NSString *const kCSPickerViewFrontCellIdentifier = @"kCSPickerViewFrontCellIdentifier";

@interface CSPickerTableView : UITableView
@property (nonatomic) CSPickerView *pickerView;
@end;

@interface CSPickerView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) CSPickerTableView *topTableView;
@property (nonatomic) CSPickerTableView *bottomTableView;
@property (nonatomic) CSPickerTableView *frontTableView;
@property (nonatomic) NSInteger count;
@property (nonatomic) CGFloat frontTableViewY;
@property (nonatomic) CGFloat frontTableViewHeight;
@property (nonatomic) CGFloat backTableViewHeight;
@property (nonatomic) CGFloat heightRatio;
@end

@implementation CSPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTables];
        [self setupScrollView];
        [self setupGradientView];
    }
    return self;
}

- (void)setupTables
{
    // Top table.
    _topTableView = [self createTableView];
    _topTableView.tag = kCSPickerViewBackTopTableTag;
    _topTableView.pickerView = self;
    [self addSubview:_topTableView];
    
    // Bottom table.
    _bottomTableView = [self createTableView];
    _bottomTableView.tag = kCSPickerViewBackBottomTableTag;
    _bottomTableView.pickerView = self;
    [self addSubview:_bottomTableView];
    
    // Front table.
    _frontTableView = [self createTableView];
    _frontTableView.tag = kCSPickerViewFrontTableTag;
    _frontTableView.delegate = self;
    [self addSubview:_frontTableView];
}

- (CSPickerTableView *)createTableView
{
    CSPickerTableView *tableView = [[CSPickerTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.userInteractionEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor clearColor];
    return tableView;
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.bounces = YES;
    [self addSubview:_scrollView];
    
    // Add tap gesture for selecting row.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:tap];
}

- (void)setupGradientView
{
    _gradientView = [[CSPickerGradientView alloc] initWithFrame:self.bounds];
    _gradientView.locations = @[ @0.0f, @0.3f, @0.7f, @1.f];
    _gradientView.CGColors = @[ (id)[UIColor blackColor].CGColor,
                                (id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
                                (id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
                                (id)[UIColor blackColor].CGColor ];
    [self addSubview:_gradientView];
}

- (void)setBounces:(BOOL)bounces
{
    _scrollView.bounces = bounces;
}

#pragma mark - Geometry

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _gradientView.frame = self.bounds;
    [self updateGeometry];
    [self scrollViewDidScroll:_frontTableView];
}

- (void)updateGeometry
{
    if (![_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return;
    }
    
    _backTableViewHeight = [_delegate tableView:_topTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _frontTableViewHeight = [_delegate tableView:_frontTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _heightRatio = _frontTableViewHeight / _backTableViewHeight;
    _frontTableViewY = (self.frame.size.height - _frontTableViewHeight) / 2.f;
    
    // Front table frame.
    _frontTableView.frame = CGRectMake(0.f, _frontTableViewY, self.frame.size.width, _frontTableViewHeight);
    // Top table frame.
    _topTableView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, _frontTableViewY);
    // Bottom table frame.
    CGFloat height = _frontTableViewY;
    if (_bottomTableView.delegate)
    {
        // Reduce bottom table height by bumber of cells.
        NSInteger numberOfRows = [self tableView:_bottomTableView numberOfRowsInSection:0];
        if (numberOfRows > 0 && [_bottomTableView.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            NSIndexPath *indexPathZero = [NSIndexPath indexPathForRow:0 inSection:0];
            height = fminf(_frontTableViewY, numberOfRows * [_bottomTableView.delegate tableView:_bottomTableView
                                                                         heightForRowAtIndexPath:indexPathZero]);
        } else {
            height = 0;
        }
    }
    _bottomTableView.frame = CGRectMake(0.f, _frontTableViewY + _frontTableViewHeight, self.frame.size.width, height);
    // Update Scroll View content size.
    [self updateScrollViewContentSize];
}

#pragma mark -

- (void)setDelegate:(id<CSPickerViewDelegate>)delegate
{
    _delegate = delegate;
    _topTableView.delegate = delegate;
    _bottomTableView.delegate = delegate;
    [self updateGeometry];
    
    // Table View customization.
    if ([_delegate respondsToSelector:@selector(pickerView:customizeTableView:)]) {
        [_delegate pickerView:self customizeTableView:_frontTableView];
        [_delegate pickerView:self customizeTableView:_topTableView];
        [_delegate pickerView:self customizeTableView:_bottomTableView];
    }
    
    if (_dataSource) {
        [self reloadData];
    }
}

- (void)setDataSource:(id<CSPickerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    if (_delegate) {
        [self reloadData];
    }
}

- (void)reloadData
{
    [_topTableView reloadData];
    [_bottomTableView reloadData];
    [_frontTableView reloadData];
    _count = [_dataSource pickerView:self numberOfRowsInTableView:_topTableView];
    [self updateScrollViewContentSize];
    [self updateGeometry];
    [self scrollViewDidScroll:_frontTableView];
}

- (void)updateScrollViewContentSize
{
    _scrollView.contentSize = CGSizeMake(self.frame.size.width,
                                         _frontTableView.contentSize.height
                                         + self.frame.size.height - _frontTableViewHeight);
}

#pragma mark - Control options

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    CGFloat alpha = userInteractionEnabled ? 1.f : 0.5f;
    _topTableView.alpha = alpha;
    _bottomTableView.alpha = alpha;
    _frontTableView.alpha = alpha;
}

- (void)setSelectedRow:(NSInteger)selectedRow
{
    [self setSelectedRow:selectedRow animated:NO];
}

- (void)setSelectedRow:(NSInteger)selectedRow animated:(BOOL)animated
{
    _selectedRow = selectedRow;
    [_scrollView setContentOffset:CGPointMake(0.f, _selectedRow * _frontTableViewHeight) animated:animated];
    
    // Delegate row selecting.
    if ([_delegate respondsToSelector:@selector(pickerView:didSelectRow:)]) {
        [_delegate pickerView:self didSelectRow:_selectedRow];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource ? [_dataSource pickerView:self numberOfRowsInTableView:tableView] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _dataSource ? [_dataSource pickerView:self tableView:tableView cellForRow:indexPath.row] : nil;
}

#pragma mark - Scroll Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _frontTableViewHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kCSPickerViewBackTopTableTag || scrollView.tag == kCSPickerViewBackBottomTableTag) {
        return;
    }
    
    if (scrollView == _scrollView) {
        [_frontTableView setContentOffset:scrollView.contentOffset animated:NO];
        return;
    }
    
    [_topTableView setNeedsLayout];
    [_bottomTableView setNeedsLayout];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        [self selectNearOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _scrollView && !decelerate) {
        [self selectNearOffset:scrollView.contentOffset];
    }
}

- (void)selectNearOffset:(CGPoint)point
{
    point.y = _frontTableViewHeight * floorf((point.y + _frontTableViewHeight / 2.f) / _frontTableViewHeight);
    [self setSelectedRow:ceilf(point.y / _frontTableViewHeight) animated:YES];
}

#pragma -

- (void)tap:(UITapGestureRecognizer *)gesture
{
    CGFloat y = [gesture locationInView:self].y;
    NSInteger rowOffset = 0;
    if (y < _topTableView.frame.size.height) {
        y = _topTableView.frame.size.height - y;
        rowOffset = -ceilf(y / _backTableViewHeight);
        
    } else if (y > _bottomTableView.frame.origin.y) {
        y -= _bottomTableView.frame.origin.y;
        rowOffset = ceilf(y / _backTableViewHeight);
    }
    
    if (rowOffset != 0) {
        NSInteger selectedRow = _selectedRow + rowOffset;
        if (selectedRow != _selectedRow && selectedRow >= 0 && selectedRow < _count) {
            [self setSelectedRow:selectedRow animated:YES];
        }
        
    } else if ([_delegate respondsToSelector:@selector(pickerView:didSelectRow:)]) {
        // Delegate row selecting.
        [_delegate pickerView:self didSelectRow:_selectedRow];
    }
}

@end

#pragma mark - Picker Table View

@implementation CSPickerTableView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_pickerView)
    {
        CGFloat y = _pickerView.scrollView.contentOffset.y / _pickerView.heightRatio;
        CGPoint contentOffset = CGPointZero;
        if (_pickerView.topTableView == self) {
            contentOffset = CGPointMake(0.f, y - _pickerView.frontTableViewY);
        } else {
            contentOffset = CGPointMake(0.f, y + _pickerView.backTableViewHeight);
        }
        [self setContentOffset:contentOffset animated:NO];
    }
}

@end


#pragma mark - Gradient View

@implementation CSPickerGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.userInteractionEnabled = NO;
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)setLocations:(NSArray *)locations
{
    ((CAGradientLayer *)self.layer).locations = locations;
}

- (void)setCGColors:(NSArray *)CGColors
{
    ((CAGradientLayer *)self.layer).colors = CGColors;
}

@end
