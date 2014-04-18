//
//  NewGameViewController.h
//  Resistance
//
//  Created by Varun Rau on 12/26/13.
//  Copyright (c) 2013 Rafael and Rau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGameViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *numPlayersPicker;
@property (nonatomic, weak) IBOutlet UITextField *nameField;

- (IBAction) createGame:(id)sender;

@end
