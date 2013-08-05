Cheapshot-PickerView
===
**Picker View for iOS**

Screenshots
---
![1](https://dl.dropboxusercontent.com/u/1280321/PickerView/1.png)
![2](https://dl.dropboxusercontent.com/u/1280321/PickerView/2.png)
![3](https://dl.dropboxusercontent.com/u/1280321/PickerView/3.png)

Adding to your project
---
1. Add `CSPickerView.h` and `CSPickerView.m` to your project;
1. Add `QuartzCore` framework in builds phases.

Usage
---
Picker works on the basis of two types of Table View, are assigned tags `kCSPickerViewBackTableTag` and `kCSPickerViewFrontTableTag`. These tags should use in the methods of the delegate and the data source.

* `kCSPickerViewBackTableTag` for the table in the back;
* `kCSPickerViewFrontTableTag` for the table in the front.

To start, create Picker View in `viewDidLoad`:

``` objective-c
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	CSPickerView *pickerView = [[CSPickerView alloc] initWithFrame:self.view.bounds];
	pickerView.delegate = self;
	pickerView.dataSource = self;
	[self.view addSubview:pickerView];
}
```

You need to add a delegate (`CSPickerViewDelegate`) and data source (`CSPickerViewDataSource`) in your class and implement the required methods:

1. `CSPickerViewDataSource`;
	1. `- (NSInteger)pickerView:(CSPickerView *)pickerView
	   numberOfRowsInTableView:(UITableView *)tableView`;
	1. `- (UITableViewCell *)pickerView:(CSPickerView *)pickerView
	                         tableView:(UITableView *)tableView 
	                        cellForRow:(NSInteger)row`;
	1. `- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath` (recommended);
1. `CSPickerViewDelegate`;
	1. `- (void)pickerView:(CSPickerView *)pickerView customizeTableView:(UITableView *)tableView` (optional);
	1. `- (void)pickerView:(CSPickerView *)pickerView didSelectRow:(NSInteger)row` (optional).

Use the tags (`kCSPickerViewBackTableTag`, `kCSPickerViewFrontTableTag`) to split the definition of a table cell to the table at the back and to the table at the front:

``` objective-c
- (UITableViewCell *)pickerView:(CSPickerView *)pickerView tableView:(UITableView *)tableView cellForRow:(NSInteger)row
{
    // Create table cell.
    NSString *identifier = (tableView.tag == kCSPickerViewFrontTableTag
                            ? kCSPickerViewFrontCellIdentifier 
                            : kCSPickerViewBackCellIdentifier);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        if (tableView.tag == kCSPickerViewBackTableTag) {
        	// Customize a cell to the table in back.
        } else {
        	// Customize a cell to the table in front.
        }
    }
    
    // Populate table cell.
    
    return cell;
}
```

I recommend using a different height cells:

``` objective-c
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.tag == kCSPickerViewFrontTableTag ? 60.f : 30.f;
}
```

A few examples implemented in the project `PickerView`.

Licence
=======
Cheapshot Picker View is available under the MIT license.