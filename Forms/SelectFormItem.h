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


@interface SelectFormItem : FormItem <UIPickerViewDelegate,UIPickerViewDataSource> {
    NSString * lookupKey;
    FormItem * filter;
    NSDictionary * propertyDictionary;
}
@property (nonatomic, copy)   NSString * lookupKey;
@property (nonatomic, retain)  FormItem * filter;
@property (nonatomic, retain)  NSDictionary * propertyDictionary;

+ (SelectFormItem*)withName:(NSString*)name withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del;
+ (SelectFormItem*)withName:(NSString*)name andFilterItem:(FormItem*)filtIt withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del;

+ (SelectFormItem*)withCell:(UITableViewCell*)lCell  withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id<FormTableDelegate>)del;

@end
