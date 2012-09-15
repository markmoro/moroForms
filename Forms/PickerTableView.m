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

#import "PickerTableView.h"


@implementation PickerTableView
@synthesize items,data,lookupKey,multi,topDictionary,backTo;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
     }
    return self;
}


- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                                          style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];

    self.view = tableView;
    [tableView release];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    selected = [[NSMutableSet alloc] initWithCapacity:20];
  //  level = 1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(multi) {
        [selected removeAllObjects];
        NSString * ds = [data valueForKey:lookupKey];
         if(ds) {
            NSArray * sels = [ds  componentsSeparatedByString:@", "];
            for(NSString * selSt in sels) {
                int place=0;
                for(NSString * item in self.items) {
                    if([item isEqualToString:selSt]) {
                        [selected addObject:[NSNumber numberWithInt:place]];
                    }
                    place++;
                }
                
            }
        }
        
    }
}


-(void)setActualTopDictionary:(NSDictionary*)dictionary {
    self.topDictionary = dictionary;
    self.items = [NSArray arrayWithArray:[[dictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];    
}


-(IBAction)finish:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(multi) {
        NSMutableArray * ma = [NSMutableArray arrayWithCapacity:[selected count]];
        for(NSNumber * sel in selected) {
            [ma addObject:[items objectAtIndex:[sel intValue]]];
        }
        [data setValue:[ma componentsJoinedByString:@", "] forKey:lookupKey];
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([backTo respondsToSelector:@selector( pickedItem:)]) {
        [backTo pickedItem:data];
    }
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [items count];
}

-(NSNumber *)numberInSelected:(int)no {
    for(NSNumber * sel in selected) {
        if([sel intValue] == no)
            return sel;
    }
    return nil;  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    id item = [items objectAtIndex:indexPath.row];
    if([item isKindOfClass:[NSDictionary class]]) 
        cell.textLabel.text = [[items objectAtIndex:indexPath.row] valueForKey:@"state"];
    else
        cell.textLabel.text = [items objectAtIndex:indexPath.row];
    if(topDictionary)
        cell.textLabel.text = [cell.textLabel.text substringFromIndex:1];
    
    
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.textLabel.numberOfLines=2;
    if(multi) {
        NSNumber * no = [self numberInSelected:indexPath.row];
        if(no) 
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
                cell.accessoryType = 0;
    } else {
        if([[data valueForKey:lookupKey] isEqualToString:cell.textLabel.text])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = 0;
    }
   
    return cell;
}



#pragma mark - Table view delegate


-(NSArray*)itemsFromArray:(NSArray*)array {
    NSMutableArray * ret = [NSMutableArray arrayWithCapacity:[array count]];
    for(NSArray * list in array) {
        [ret addObject:[list objectAtIndex:1]];
    }
    return ret;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.topDictionary) {
        PickerTableView * pickerTableView = [[PickerTableView alloc] initWithNibName:nil bundle:nil];
        pickerTableView.multi = self.multi;
        pickerTableView.items = [self itemsFromArray:[self.topDictionary valueForKey:[items objectAtIndex:indexPath.row]]];
        pickerTableView.data = data;
        pickerTableView.backTo =backTo;
        pickerTableView.lookupKey =self.lookupKey;
        [self.navigationController pushViewController:pickerTableView animated:YES];
        [pickerTableView release];
    } else  {
        if(multi) {
            NSNumber * no = [self numberInSelected:indexPath.row];
            if(no) {
                [selected removeObject:no];
            } else {
                [selected addObject:[NSNumber numberWithInt:indexPath.row]];
            }
            [tableView reloadData];
        } else {
            [data setValue:[items objectAtIndex:indexPath.row] forKey:lookupKey];

            [self.navigationController popToViewController:backTo animated:YES];
        }
    }
}

-(void)dealloc {
    if(backTo)
        [backTo release];
    if(items)
        [items release];
    if(topDictionary)
        [topDictionary release];
    if(data)
        [data release];
    [super dealloc];
    
}

@end
