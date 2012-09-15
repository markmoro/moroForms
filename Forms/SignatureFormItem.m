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

#import "SignatureFormItem.h"

@implementation SignatureFormItem

@synthesize signatureView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (FormItem*)withCell:(UITableViewCell*)lCell withName:(NSString*)name withCoreDataKey:(NSString*)key andDelegate:(id)del
{
    SignatureFormItem * ret = [[SignatureFormItem alloc] init];
    ret.cell = lCell;
    ret.fieldType = ftSignature;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.name = name;
    ret.editble =YES;

    for(UIView * sc in lCell.contentView.subviews) {
        if(sc.tag == 99) {
            ret.signatureView = (SignatureView *) sc;
            ret.signatureView.delegate = ret;
        }
    }
    return [ret autorelease];
}


-(void)saveSignature:(NSObject*)mo {
    // get data here and store
    CGImageRef cgImage = CGBitmapContextCreateImage(signatureView.context);
    UIImage *img = [UIImage imageWithCGImage:cgImage];
    NSData *dataObj = UIImagePNGRepresentation(img);
    [mo setValue:dataObj forKey:self.coredataKey];
}

-(void)reloadValueForObject:(NSObject*)mo {

}

-(NSString*)getItemStringFrom:(NSObject*)mo {

        return @"Signature";
}

-(NSString*)getFieldName {
    return self.coredataKey;
}

-(void)touchStarted {
     [delegate  textFieldShouldBeginEditingForm:self];
    
}

-(void)clear {
    [self.signatureView clear];
    
}

-(void)dealloc {
    if(signatureView) 
        [signatureView release];
    [super dealloc];
}

@end
