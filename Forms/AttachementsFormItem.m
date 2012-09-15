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

#import "AttachementsFormItem.h"

@implementation AttachementsFormItem

@synthesize imageView;





+ (AttachementsFormItem*)withCell:(UITableViewCell*)lCell  withCoreDataKey:(NSString*)key andDelegate:(id)del
{
    AttachementsFormItem * ret = [[AttachementsFormItem alloc] init];
    ret.cell = lCell;
    ret.fieldType = ftAttachment;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.editble =YES;

    
    for(UIView * sc in lCell.contentView.subviews) {
        if(sc.tag == 99) {
            ret.imageView = (UIImageView *) sc;
        }
    }

    return [ret autorelease];
}


-(void)saveAttachement:(UIImage*)img to:(NSObject*)mo {
    // get data here and store    
    NSData *dataObj = UIImageJPEGRepresentation(img, 0.7);
    [mo setValue:dataObj forKey:self.coredataKey];
}

-(void)reloadValueForObject:(NSObject*)mo {
    NSData *dataObj = [mo valueForKey:self.coredataKey];
    if(dataObj) {
        imageView.image = [UIImage imageWithData:dataObj];
    } else
        imageView.image = nil;
    
}

-(NSString*)getItemStringFrom:(NSObject*)mo {
    
    return @"Attachement";
}

-(NSString*)getFieldName {
    return self.coredataKey;
}

-(void)dealloc {
    if(imageView)
        [imageView release];
    [super dealloc];
}
@end
