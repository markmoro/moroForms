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

#import "BaseFormTableController.h"

#import "BaseForm.h"
#import "PickerTableView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MultiSectionView.h"

@implementation BaseFormTableController
@synthesize items,datePicker,valuePicker,currentField;
@synthesize data;

@synthesize tableView;



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}


-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tableView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(currentField && currentField.textField) 
        [currentField.textField resignFirstResponder];
    
}

-(void)copyDataToMo:(NSManagedObject*)destObj {
    for(FormItem * fi in self.items) {
        [destObj setValue:[data valueForKey:fi.coredataKey] forKey:fi.coredataKey];
    }
    
}

-(void)copyMoToData:(NSManagedObject*)destObj {
    for(FormItem * fi in self.items) {
        [data setValue:[destObj valueForKey:fi.coredataKey] forKey:fi.coredataKey];
    }
    
}

-(void)resetSize {
    self.view.frame =CGRectMake(0,0 ,320,360);
    self.tableView.frame =CGRectMake(0,0 ,320,360);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count]; 
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [(FormItem*)[items objectAtIndex:indexPath.row] cell];
    return cell.bounds.size.height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSIndexPath *)indexPath {
    return 10;
    
}


-(BOOL)isEditable {
    return YES;

}

-(void)setDataValueAct:(id)dt forKey:(NSString *)key {

    [data setValue:dt forKey:key];
    
}

-(void)openAttachmentView:(BOOL)isCam {
 
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if(isCam) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        cameraUI.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum ;
    
    }
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];


    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = self;
    
    [self presentModalViewController: cameraUI animated: YES];
    [cameraUI release];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage; //, *editedImage, *imageToUse;
    
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    
    [(AttachementsFormItem*)currentField saveAttachement:originalImage to:data] ;

       

    [self dismissModalViewControllerAnimated: YES];
    [self.tableView reloadData];
    [picker release];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [self dismissModalViewControllerAnimated: YES];
    [picker release];
}


- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self openAttachmentView:NO];
            break;
        case 2:
            [self openAttachmentView:YES];
            break;
        default:
            break;
    }
} // clickedButtonAtIndex


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


- (void)tableView:(UITableView *)ltableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormItem * ft = [items objectAtIndex:indexPath.row];
    if([self isEditable] && ft.editble) {
        
 
        

        if(ft.fieldType == ftAttachment) {
            self.currentField = ft;
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Attachement"
                                       message: @"Choose source."
                                      delegate: self
                             cancelButtonTitle: @"Cancel"
                             otherButtonTitles: @"Photo Album",@"Camera", nil];
            [alert show];
            [alert release];
            
         }  else  if(ft.fieldType == ftSignature) {
              [ltableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES]; 
            tableView.scrollEnabled = NO;
            UIBarButtonItem * endButtonItem = [[[UIBarButtonItem alloc]
                                                initWithTitle:@"Done"
                                                style:UIBarButtonItemStylePlain    
                                                target:self
                                                action:@selector(endEdit:)] autorelease];
            self.navigationItem.rightBarButtonItem = endButtonItem;
            self.currentField = ft;
            [(SignatureFormItem*)ft clear];
        }
        else
        if(ft.fieldType == ftSelectPage || ft.fieldType == ftMultiSelect  ) {
            PickerTableView * pickerTableView = [[PickerTableView alloc] initWithNibName:nil bundle:nil];
            pickerTableView.multi = (ft.fieldType == ftMultiSelect);
            
   
                pickerTableView.items = [ft listOfItems] ;
       
            pickerTableView.backTo = self;
            pickerTableView.data = data;
            pickerTableView.lookupKey =ft.coredataKey;
            [self.navigationController pushViewController:pickerTableView animated:YES];
            [pickerTableView release];

            
        } else   if(ft.fieldType == ftMultiSectionSelect  ) {
            MultiSectionView * pickerTableView = [[MultiSectionView alloc] initWithNibName:nil bundle:nil];
            pickerTableView.items = [ft listOfItems] ;
            pickerTableView.data = data;
            pickerTableView.lookupKey =ft.coredataKey;
            [self.navigationController pushViewController:pickerTableView animated:YES];
            [pickerTableView release];
            
            
        }
        else
        if(ft.textField) {
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.frame = CGRectMake(0,0,320,220);
            }];
            [ltableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES]; // Scroll your row to 
            ft.textField.enabled =YES;
            [ft.textField becomeFirstResponder];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  
}

-(void)reload {
        [self.tableView reloadData];
    
}

-(void)updateRelatedFields {
    
    
}


- (IBAction)endEdit:(id)sender {
    tableView.scrollEnabled = YES;
    if(self.currentField.fieldType == ftPredict || self.currentField.fieldType == ftSQLPredict) {
        [((AutoCompleteFormItem*)self.currentField).autocompleteTableView removeFromSuperview];
    }
    if(self.currentField.fieldType == ftSignature) {
        [(SignatureFormItem*)self.currentField saveSignature:data];
        [self updateRelatedFields];
        self.currentField = nil;
        self.navigationItem.rightBarButtonItem = nil;

        [self.tableView reloadData];
        return;
        
        
    }
    self.navigationItem.rightBarButtonItem = nil;
    if(self.currentField.textField) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0,0,320,370);
        }];
        [self.currentField.textField resignFirstResponder];
        self.currentField.textField.enabled =NO;
       
    }
    [self updateRelatedFields];
    self.currentField = nil;
    [self.tableView reloadData];
}



- (BOOL)textFieldShouldBeginEditingForm:(id)textField {
    return [self isEditable ];
}

- (void)textFieldDidBeginEditingForm:(id)formItem {
    self.currentField = (FormItem*)formItem;
    UIBarButtonItem * endButtonItem = [[[UIBarButtonItem alloc]
                      initWithTitle:@"Done"
                      style:UIBarButtonItemStylePlain    
                      target:self
                      action:@selector(endEdit:)] autorelease];
 
    self.navigationItem.rightBarButtonItem = endButtonItem;
    if(((FormItem*)formItem).fieldType == ftPredict  ||
       ((FormItem*)formItem).fieldType == ftSQLPredict) {
        [self.view addSubview:((AutoCompleteFormItem*)formItem).autocompleteTableView];        
    }

       
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NO;
}

-(void)dealloc {
    if(items)
        [items release];
    if(data)
        [data release];
    if(datePicker)
        [datePicker release];
    if(valuePicker)
        [valuePicker release];
    if(currentField)
        [currentField release];
    if(tableView)
        [tableView release];

    [super dealloc];
}

@end
