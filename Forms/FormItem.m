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

#import "FormItem.h"
#import "CustomTextField.h"

@implementation FormItem
@synthesize  cell, fieldType, coredataKey, dataTable, dataKey,delegate,textField,name,editble,required,fid;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


+( UITableViewCell *)createGenericTextField:(NSString*)name {
    UITableViewCell * lCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(11,13, SPLIT_POINT+115, 21)];
    label.text = name;
    label.textAlignment = UITextAlignmentLeft;
    label.font =[UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor blackColor]; 
    label.backgroundColor = [UIColor clearColor];
    UITextField * textfield = [[CustomTextField alloc] initWithFrame:CGRectMake(SPLIT_POINT-15, 15, 201, 21)];
    textfield.placeholder = name;
    textfield.tag = 99;
    textfield.font = [UIFont boldSystemFontOfSize:14];
    textfield.textAlignment = UITextAlignmentRight;
    textfield.textColor = [UIColor colorWithRed:0.27 green:0.53 blue:0.57 alpha:1.0]; 
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 21)] autorelease];
    textfield.rightView = paddingView;
   textfield.rightViewMode = UITextFieldViewModeWhileEditing;
    [lCell.contentView addSubview:label];
    [lCell.contentView addSubview:textfield];
    [label release];
    [textfield release];
    [lCell autorelease];
    return lCell;
}


+ (FormItem*)withName:(NSString*)name ofType:(FieldType)ft withCoreDataKey:(NSString*)key andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    FormItem * fi = [self withCell:(UITableViewCell*)lCell ofType:(FieldType)ft withCoreDataKey:(NSString*)key andDelegate:(id)del];
    fi.name = name;
    return fi;
}

+ (FormItem*)withCell:(UITableViewCell*)lCell ofType:(FieldType)ft withCoreDataKey:(NSString*)key andDelegate:(id)del
{
    FormItem * ret = [[FormItem alloc] init];
    ret.cell = lCell;
    ret.fieldType = ft;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.name = [key capitalizedString];
    ret.editble =YES;
    
    if(ft == ftNumber || ft == ftPhone  ) {
        for(UIView * sc in lCell.contentView.subviews) {
            if(sc.tag == 99) {
                ret.textField = (UITextField *) sc;
                ret.textField.keyboardType = UIKeyboardTypeNumberPad;
                ret.textField.delegate =ret;
                ret.textField.placeholder = @"-";
            }
        }
    } else if(ft == ftDecimal) {
        for(UIView * sc in lCell.contentView.subviews) {
            if(sc.tag == 99) {
                ret.textField = (UITextField *) sc;
                ret.textField.keyboardType = UIKeyboardTypeDecimalPad;
                ret.textField.delegate =ret;
                ret.textField.placeholder = @"-";
            }
        }
    } else  {
        for(UIView * sc in lCell.contentView.subviews) {
            if(sc.tag == 99) {
                ret.textField = (UITextField *) sc;
                ret.textField.delegate =ret;
            }
        }  
        
    }
    
 //   ret.textField.textColor = [blackColor];
    ret.textField.enabled =NO;
    return [ret autorelease];
}

-(void)setValueOfField:(NSString*)v {
    [delegate setDataValueAct:v forKey:self.coredataKey];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)ltextField {
    ltextField.textColor = [UIColor blackColor];
    return  [delegate  textFieldShouldBeginEditingForm:self];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [delegate  textFieldDidBeginEditingForm:self];
}
/*

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string {  
    if(theTextField.text) {
        
        if([theTextField.text length] == 0 || [theTextField.text characterAtIndex:[theTextField.text length]-1] != ' ') {
            theTextField.text = [[theTextField.text stringByAppendingString:string] stringByAppendingString:@" "];
            return NO;
        } else {
            theTextField.text = [theTextField.text substringToIndex:[theTextField.text length]-1];
            theTextField.text = [[theTextField.text stringByAppendingString:string] stringByAppendingString:@" "]; 
            return NO;
        }
        
    } 
    return YES;
}
*/
- (void)textFieldDidEndEditing:(UITextField *)ltextField {
        ltextField.textColor = [UIColor colorWithRed:0.27 green:0.53 blue:0.57 alpha:1.0];
    NSString * vv = ltextField.text ;
 /*   if([vv  characterAtIndex:[vv length]-1] == ' ') {
        vv = [vv substringToIndex:[vv length]-1];
    }*/
    [delegate setDataValueAct:vv forKey:self.coredataKey];
}

-(void)reloadValueForObject:(NSObject*)mo {
    if(fieldType != ftAttachment)
    textField.text = [mo valueForKey:self.coredataKey];
    self.fid = textField.text;

}

-(NSString*)getItemStringFrom:(NSObject*)mo {
    id ret = [mo valueForKey:self.coredataKey];
    if(ret)
        return ret;
    else
        return @"";
}


-(NSString*)getFieldName {
    return self.coredataKey;
}

-(void)dealloc {
    if(cell)
        [cell release];
    if(textField)
        [textField release];
    if(delegate)
        [delegate release];
    [super dealloc];
}

-(NSArray*)listOfItems {
    return [NSArray array];
}
@end
