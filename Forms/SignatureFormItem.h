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
#import "SignatureView.h"

@interface SignatureFormItem : FormItem {
    SignatureView * signatureView;
    
}

@property (nonatomic, retain) SignatureView * signatureView;


+ (FormItem*)withCell:(UITableViewCell*)lCell withName:(NSString*)name  withCoreDataKey:(NSString*)key andDelegate:(id<FormTableDelegate>)delegate;


-(void)reloadValueForObject:(NSObject*)mo;

-(NSString*)getItemStringFrom:(NSObject*)mo;
-(NSString*)getFieldName;

-(void)touchStarted;
-(void)saveSignature:(NSObject*)mo;
-(void)clear;
@end
