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

#import "SelectPageItem.h"
#import "AutoDataSingleton.h"


@implementation SelectPageItem
@synthesize lookupKey;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (SelectPageItem*)withName:(NSString*)name andType:(FieldType)ft withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    SelectPageItem* ret = [self withCell:(UITableViewCell*)lCell andType:(FieldType)ft  withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del];
    ret.name = name;
    return ret;
}


+ (SelectPageItem*)withName:(NSString*)name andFilter:(NSString*)filtIt andType:(FieldType)ft withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    SelectPageItem* ret = [self withCell:(UITableViewCell*)lCell andType:(FieldType)ft  withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del];
    ret.name = name;
    ret.fid = filtIt;
    return ret;
}

+ (SelectPageItem*)withCell:(UITableViewCell*)lCell andType:(FieldType)ft  withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    SelectPageItem * ret = [[SelectPageItem alloc] init];
    ret.cell = lCell;
    ret.fieldType = ft;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.lookupKey= lookup;
    ret.name =  [key capitalizedString];

    ret.editble =YES;

    for(UIView * sc in lCell.contentView.subviews) {
        if(sc.tag == 99) {
            ret.textField  = (UITextField *) sc;
            UIPickerView * dp = [[UIPickerView alloc] initWithFrame:CGRectZero];
            ret.textField.delegate =ret;
            dp.dataSource = ret;
            dp.delegate = ret;
            dp.showsSelectionIndicator =YES;
            ret.textField.enabled = NO;
      //      ret.textField.inputView = dp;
        //    ret.textField.inputAccessoryView = dp;
            [dp release];
        }
        if([sc isKindOfClass:[UILabel class]]) {
            ret.name = [((UILabel*)sc) text];
        }
    }
    
    
    return [ret autorelease];
}

- (void)textFieldDidEndEditing:(UITextField *)ltextField {
    
    UIPickerView * dp = (UIPickerView *)ltextField.inputView;
    int row = [dp selectedRowInComponent:0];
    NSString * val  =[dp.delegate pickerView:dp titleForRow:row forComponent:0];
    self.fid = val;
    [delegate setDataValueAct:val forKey:self.coredataKey];
    [delegate updateRelatedFields];
    
}

-(NSArray*)listOfItems {
    if(self.fid) {
        return [[AutoDataSingleton sharedAutoDataSingleton] listForKey:lookupKey withFilter:self.fid];
    }
        return [[AutoDataSingleton sharedAutoDataSingleton] listForKey:lookupKey];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  0;
}
@end
