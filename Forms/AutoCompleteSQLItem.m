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

#import "AutoCompleteSQLItem.h"
#import "AutoDataSingleton.h"

@implementation AutoCompleteSQLItem
@synthesize autocompleteTableView,lookupKey,addressKey,filter,filter2,filter3
;

- (id)init
{
    self = [super init];
    if (self) {
        autoCompItems = [[NSMutableArray alloc] initWithCapacity:200];
        autoCompIds =[[NSMutableArray alloc] initWithCapacity:200];
    }
    
    return self;
}

-(void)setMask {
    if (!maskLayer)
    {
        maskLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        
        maskLayer.colors = [NSArray arrayWithObjects:(id)outerColor, 
                            (id)innerColor, (id)innerColor, (id)outerColor, nil];
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], 
                               [NSNumber numberWithFloat:0.2], 
                               [NSNumber numberWithFloat:0.8], 
                               [NSNumber numberWithFloat:1.0], nil];
        
        maskLayer.bounds = CGRectMake(0, 0,
                                      self.autocompleteTableView.frame.size.width,
                                      self.autocompleteTableView.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        self.autocompleteTableView.layer.mask = maskLayer;
    }
    
}

+ (FormItem*)withName:(NSString*)name withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    AutoCompleteSQLItem* ret = [self withCell:(UITableViewCell*)lCell withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del];
    ret.name = name;
    return ret;
}


+ (FormItem*)withName:(NSString*)name andFilterItem:(FormItem*)filtIt withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    UITableViewCell * lCell =  [FormItem createGenericTextField:name];
    AutoCompleteSQLItem* ret = [self withCell:(UITableViewCell*)lCell withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del];
    ret.name = name;
    ret.filter = filtIt;
    return ret;
    
}

+ (AutoCompleteSQLItem*)withCell:(UITableViewCell*)lCell withCoreDataKey:(NSString*)key andLookUp:(NSString*)lookup andDelegate:(id)del
{
    AutoCompleteSQLItem * ret = [NSAllocateObject([self class], 0, NULL) init];
    ret.cell = lCell;
    ret.fieldType = ftSQLPredict;
    ret.coredataKey = key;
    ret.delegate = del;
    ret.lookupKey= lookup;
    ret.editble =YES;

    
    for(UIView * sc in lCell.contentView.subviews) {
        if(sc.tag == 99) {
            ret.textField = (UITextField *) sc;
            ret.textField.delegate =ret;
        }
    }
    ret.autocompleteTableView = [[UITableView alloc] initWithFrame:
                                 CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
    ret.autocompleteTableView.delegate = ret;
    ret.autocompleteTableView.dataSource = ret;
    ret.autocompleteTableView.scrollEnabled = YES;
    ret.autocompleteTableView.hidden = YES;  
    ret.textField.enabled =NO;

    [ret setMask];
    
    return [ret autorelease];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

/*
-(NSString*)fid {
    NSString * retSt =@"";
    if(textField.text) {
        NSArray * coms = [textField.text componentsSeparatedByString:@" "];
        if([coms count] > 0 )
            retSt = [coms objectAtIndex:[coms count]-1];
    }
    return retSt;
}
*/
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [autoCompItems removeAllObjects];
    [autoCompIds removeAllObjects];

}


- (BOOL)textField:(UITextField *)ltextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:ltextField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];


    return YES;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 //   NSLog(@"items %d",[autoCompItems count]);
    return [autoCompItems count]; 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ASQLCell";
    
    UITableViewCell *lcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (lcell == nil) {
        lcell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    lcell.textLabel.text = [autoCompItems objectAtIndex:indexPath.row];
    return lcell;
}



- (void)textFieldDidEndEditing:(UITextField *)ltextField {
    [delegate setDataValueAct:ltextField.text forKey:self.coredataKey];


    [delegate reload];
}

-(void)reloadValueForObject:(NSObject*)mo {
    textField.text = [mo valueForKey:self.coredataKey];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * text =  [autoCompItems objectAtIndex:indexPath.row];

    
    
    NSString * listee_id =  [autoCompIds objectAtIndex:indexPath.row];
    
    addressKey = listee_id;
    self.fid = listee_id;


    textField.text = text;



    [delegate endEdit:self];
    
}


-(void)dealloc {
    if(autocompleteTableView) 
        [autocompleteTableView release];

    if(filter) 
        [filter release];

    if(filter2) 
        [filter2 release];

    if(filter3) 
        [filter3 release];

                
    [super dealloc];
}
@end
