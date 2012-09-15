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

#import "DateFormItem.h"

@implementation DateFormItem

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


+ (FormItem*)withName:(NSString*)name withCoreDataKey:(NSString*)key andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    FormItem* ret = [self withCell:(UITableViewCell*)lCell withCoreDataKey:(NSString*)key andDelegate:(id)del];
    ret.name = name;
    return ret;
}

+ (FormItem*)withCell:(UITableViewCell*)lCell withCoreDataKey:(NSString*)key andDelegate:(id)del
{
    DateFormItem * ret = [[DateFormItem alloc] init];
    ret.cell = lCell;
    ret.fieldType = ftDate;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.name = [key capitalizedString];
    ret.editble =YES;


    for(UIView * sc in lCell.contentView.subviews) {
        if(sc.tag == 99) {
            ret.textField = (UITextField *) sc;
            ret.textField.delegate =ret;
            UIDatePicker * dp = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            ret.textField.inputView = dp;
            ret.textField.inputAccessoryView = dp;
            [dp release];
        }
    }

    
    return [ret autorelease];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return [delegate textFieldShouldBeginEditingForm:self];
}
- (void)textFieldDidEndEditing:(UITextField *)ltextField {

    UIDatePicker *pick = (UIDatePicker *)ltextField.inputView;

    [delegate setDataValueAct:pick.date forKey:self.coredataKey];

}

-(void)reloadValueForObject:(NSObject*)mo {

    NSDate * date = [mo valueForKey:self.coredataKey];
    if(date) {
        textField.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
    }


}

-(NSString*)getItemStringFrom:(NSObject*)mo {
    NSDate * date = [mo valueForKey:self.coredataKey];
    if(date) {
        return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
    }
    return @"Not Set";
}



@end
