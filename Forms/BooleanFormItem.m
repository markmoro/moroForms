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

#import "BooleanFormItem.h"

@implementation BooleanFormItem

@synthesize formSwitch;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}




+ (FormItem*)withName:(NSString*)name  withCoreDataKey:(NSString*)key andDelegate:(id)del {
    UITableViewCell * lCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(11,13, SPLIT_POINT+75, 21)];
    label.text = name;
    label.textAlignment = UITextAlignmentLeft;
    label.font =[UIFont boldSystemFontOfSize:14];
 //   label.textColor = [UIColor colorWithRed:0.27 green:0.53 blue:0.57 alpha:1.0]; 
    label.textColor = [UIColor blackColor]; 
    label.backgroundColor = [UIColor clearColor];

    UISwitch * lsw = [[UISwitch alloc] initWithFrame:CGRectMake(188, 8, 94, 22)];
    

    lsw.tag = 99;
    [lCell.contentView addSubview:label];
    [lCell.contentView addSubview:lsw];
    [label release];
    [lsw release];
     
    FormItem * ret = [self withCell:lCell  withCoreDataKey:key andDelegate:del];
//    [lCell autorelease];

    ret.name = name;
    return ret;
    
}

+ (FormItem*)withCell:(UITableViewCell*)lCell  withCoreDataKey:(NSString*)key andDelegate:(id)del
{
    BooleanFormItem * ret = [NSAllocateObject([self class], 0, NULL) init];
    ret.cell = lCell;
    ret.fieldType = ftBoolen;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.name = key;
    ret.editble =YES;

    
    for(UIView * sc in lCell.contentView.subviews) {
        if(sc.tag == 99) {
            ret.formSwitch  = (UISwitch *) sc;
            [(UISwitch*)sc addTarget:ret action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];

        }
    }
    
    
    return [ret autorelease];
}

-(void)switchChanged {
    [delegate setDataValueAct:[NSNumber numberWithBool:formSwitch.on] forKey:self.coredataKey];
    [delegate reload];
}

-(void)reloadValueForObject:(NSObject*)mo {
    BOOL state = NO;
    NSNumber * val = [mo valueForKey:self.coredataKey];
    if(val != nil)
        state = [[mo valueForKey:self.coredataKey] boolValue];

    [formSwitch setOn:state];
}


-(NSString*)getItemStringFrom:(NSObject*)mo {
    BOOL state = NO;
    NSNumber * val = [mo valueForKey:self.coredataKey];
    if(val != nil)
        state = [[mo valueForKey:self.coredataKey] boolValue];
    return state ? @"YES" : @"NO";
}

-(void)dealloc {
    if(formSwitch)
        [formSwitch release];
    [super dealloc];
}
@end
