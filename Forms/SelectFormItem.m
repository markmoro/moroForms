//
// Moroku iOS Forms library
// Copyright (C) 2012 Moroku Pty Ltd.
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//

#import "SelectFormItem.h"
#import "AutoDataSingleton.h"
@implementation SelectFormItem
@synthesize lookupKey,filter,propertyDictionary;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (SelectFormItem*)withName:(NSString*)name withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    SelectFormItem * ret = [self withCell:(UITableViewCell*)lCell withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del];
    ret.name = name;
    return ret;
}

+ (FormItem*)withName:(NSString*)name andFilterItem:(FormItem*)filtIt withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    SelectFormItem * ret = [self withCell:(UITableViewCell*)lCell withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del];
    ret.name = name;
    ret.filter = filtIt;
    return ret;
}



+ (SelectFormItem*)withCell:(UITableViewCell*)lCell  withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    SelectFormItem * ret = [[SelectFormItem alloc] init];
    ret.cell = lCell;
    ret.fieldType = ftSelect;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.lookupKey= lookup;
    ret.name =  [key capitalizedString];;
    ret.filter =nil;
    ret.editble =YES;
    
    for(UIView * sc in lCell.contentView.subviews) {
        if(sc.tag == 99) {
            ret.textField  = (UITextField *) sc;
            UIPickerView * dp = [[UIPickerView alloc] initWithFrame:CGRectZero];
            ret.textField.delegate =ret;
            dp.dataSource = ret;
            dp.delegate = ret;
            dp.showsSelectionIndicator =NO;
            ret.textField.inputView = dp;
            ret.textField.inputAccessoryView = dp;
            [dp release];
        }
    }

    
    return [ret autorelease];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)textFieldDidBeginEditing:(UITextField *)ltextField {
    [delegate  textFieldDidBeginEditingForm:self];
    [ltextField.inputView reloadAllComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(filter)
        return  [[[AutoDataSingleton sharedAutoDataSingleton] listForKey:lookupKey withFilter:[filter fid]] count];
   else
        return  [[[AutoDataSingleton sharedAutoDataSingleton] listForKey:lookupKey] count]; 

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 10.0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    
    CGSize limitSize = CGSizeMake(320.0, 100.0f);
    CGSize textSize;
    CGRect labelRect;
    NSString *title = [self  pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component];
    
    
    textSize = [title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:limitSize lineBreakMode:UILineBreakModeWordWrap];
    labelRect = CGRectMake(0, 0, textSize.width, textSize.height);

    if (pickerLabel == nil)
    {
        pickerLabel = [[[UILabel alloc] initWithFrame:labelRect] autorelease];
    }
    
    [pickerLabel setText:title];    
    return pickerLabel;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return [[[AutoDataSingleton sharedAutoDataSingleton] listForKey:lookupKey] objectAtIndex:row]; 
}



- (void)textFieldDidEndEditing:(UITextField *)ltextField {

        UIPickerView * dp = (UIPickerView *)ltextField.inputView;
        int row = [dp selectedRowInComponent:0];
        NSString * val  =[dp.delegate pickerView:dp titleForRow:row forComponent:0];
        [delegate setDataValueAct:val forKey:self.coredataKey];
    self.fid = val;
     [delegate reload];
        
}

-(void)dealloc {
    if(filter)
        [filter release];
    if(propertyDictionary) 
        [propertyDictionary release];
    [super dealloc];
}

@end
