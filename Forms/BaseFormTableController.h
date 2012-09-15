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


#import <UIKit/UIKit.h>
#import "FormItem.h"
#import "FormTableDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>


@interface BaseFormTableController : UIViewController <FormTableDelegate> {
    NSArray * items;
    
    UIDatePicker *datePicker;
    UIPickerView *valuePicker;

    FormItem * currentField;
    
    NSObject * data;
    UITableView * tableView;

    
    UIButton *saveButton;
    UIButton *draftButton;
    UIButton *saveNextButton;
    CAGradientLayer *maskLayer;

}

@property (nonatomic, retain) IBOutlet  NSArray * items;
@property (nonatomic, retain) IBOutlet NSObject * data;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIPickerView *valuePicker;
@property (nonatomic, retain) IBOutlet FormItem * currentField;
@property (nonatomic, retain) IBOutlet UITableView * tableView;

-(void)copyDataToMo:(NSManagedObject*)destObj;
-(void)copyMoToData:(NSManagedObject*)destObj;
-(void)setDataValueAct:(id)dt forKey:(NSString *)key;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
@end
