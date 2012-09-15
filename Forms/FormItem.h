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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FormTableDelegate.h"
#import "FilterIF.h"

typedef enum {
    ftString,
    ftBoolen,
    ftDate,
    ftNumber,
    ftSelect,
    ftSelectPage,
    ftMultiSelect,
    ftPredict,
    ftDecimal,
    ftAttachment,
    ftSignature,
    ftPhone,
    ftMultiSectionSelect,
    ftSQLPredict,
    ftCustomField1,
    ftCustomField2,
    ftCustomField3
    
} FieldType;


#define SPLIT_POINT 97

@interface FormItem : NSObject  <UITextFieldDelegate,FilterIF> {
    UITableViewCell * cell;
    FieldType fieldType;
    NSString * coredataKey;
    NSString * name;
    
    //  Used for select and predict
    NSString * dataTable;
    NSString * dataKey;
 
    id delegate;
     NSString *  fid;
    UITextField * textField;
}

@property (nonatomic, retain) UITableViewCell * cell;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, retain) UITextField * textField;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) FieldType fieldType;
@property (nonatomic, copy) NSString * coredataKey;
@property (nonatomic, copy)   NSString *  fid;

//  Used for select and predict
@property (nonatomic, copy) NSString * dataTable;
@property (nonatomic, copy) NSString * dataKey;
@property (nonatomic, assign) BOOL editble;
@property (nonatomic, assign) BOOL required;



+( UITableViewCell *)createGenericTextField:(NSString*)name;

+ (FormItem*)withName:(NSString*)name ofType:(FieldType)ft withCoreDataKey:(NSString*)key andDelegate:(id)del;

+ (FormItem*)withCell:(UITableViewCell*)lCell ofType:(FieldType)ft withCoreDataKey:(NSString*)key andDelegate:(id<FormTableDelegate>)delegate;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (void)textFieldDidEndEditing:(UITextField *)textField;
-(void)reloadValueForObject:(NSObject*)mo;

-(NSString*)getItemStringFrom:(NSObject*)mo;
-(NSString*)getFieldName;
   
-(void)setValueOfField:(NSString*)v;
-(NSArray*)listOfItems;
@end
