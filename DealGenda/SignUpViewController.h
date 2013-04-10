//
//  SignUpViewController.h
//  DealGenda
//
//  Created by Douglas Abrams on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesViewController.h"

@interface SignUpViewController : UIViewController{
    IBOutlet UIScrollView *scrollView;
    
}

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;

-(IBAction) dismissKeyboard:(id)sender;
-(IBAction) slideFrameUp;
-(IBAction) slideFrameDown;
-(IBAction)continueButton:(UIButton *)sender;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthDate;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *verifyPassword;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *canSegue;


@end
