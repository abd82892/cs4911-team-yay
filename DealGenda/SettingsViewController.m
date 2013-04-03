//
//  SettingsViewController.m
//  DealGenda
//
//  Created by Jenelle Walker on 2/11/13.
//  Copyright (c) 2013 Douglas Abrams. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "Queries.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize activeField;
@synthesize scrollView;
@synthesize username;

- (void)viewWillAppear:(BOOL)animated
{
    //_emailTextField.textColor = [UIColor grayColor];
    _emailTextField.placeholder = username;
    _pwTextField.text = @"";
    _verifyTextField.text = @"";
    _emailLabel.text = @"";
    _pwLengthLabel.text = @"";
    _pwLabel.text = @"";
    _loginLabel.text = @"";
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateInputCallback:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
    
    
    self.emailTextField.tag = 0;
    self.verifyTextField.tag = 1;
    
    self.emailTextField.delegate = self;
    self.pwTextField.delegate = self;
    self.verifyTextField.delegate = self;
    
    username = @"jdoe@email.com";
    //_emailTextField.textColor = [UIColor grayColor];
    _emailTextField.placeholder = username;
    [_saveButton setEnabled:NO];

}

- (BOOL)validateInputWithString:(UITextField *)aTextField {
    if(aTextField.tag == 0) {
        NSString * const regularExpression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSError *error = NULL;
        NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        if (error) {
            NSLog(@"error %@", error);
        }
        NSUInteger numberOfMatches = [regEx numberOfMatchesInString:aTextField.text
                                                            options:0
                                                              range:NSMakeRange(0, [aTextField.text length])];
        return numberOfMatches > 0;
    } else {
        return [_verifyTextField.text isEqualToString: _pwTextField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)aTextField
{
    if([_emailTextField.text isEqual: @""]) {
        _emailLabel.text = @"";
        
    }
    [self validateInputWithString:aTextField];
    activeField = nil;
    return YES;
}

- (void)validateInputCallback:(id)sender
{
    bool emailGo = true;
    bool passwordGo = true;
    
    //reset this label when changing input
    _loginLabel.text = @"";
    
    if(_emailTextField.isFirstResponder)
    {
        _emailTextField.textColor = [UIColor blackColor];
        if ([self validateInputWithString:_emailTextField] && _emailTextField.text.length > 5) {
            _emailLabel.text = @"";
            emailGo = true;
        }
        else {
            _emailLabel.textColor = [UIColor redColor];
            _emailLabel.font = [_loginLabel.font fontWithSize:12];
            _emailLabel.text = @"Please enter a valid email.";
            emailGo = false;
        }
    } 
    
    if(_pwTextField.isFirstResponder || _verifyTextField.isFirstResponder)
    {
        if(_pwTextField.text.length < 6)
        {
            _pwLengthLabel.font = [_pwLengthLabel.font fontWithSize:12];
            _pwLengthLabel.textColor = [UIColor redColor];
            _pwLengthLabel.text =@"Must be at least 6 characters long.";
            _pwLabel.textColor = [UIColor redColor];
            _pwLabel.text = @"X";
            passwordGo = false;
        } else {
            _pwLengthLabel.text=@"";
            if ([self validateInputWithString:_verifyTextField]) {
                _pwLabel.textColor = [UIColor greenColor];
                _pwLabel.text = @"✓";
                passwordGo = true;
            }
        }
    }
    if(emailGo == true || passwordGo == true) {
        [_saveButton setEnabled:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveSettings:(id)sender {
    bool validEmail = (_emailTextField.text.length > 3) && ![Queries validateEmail:_emailTextField.text];
    bool validPassword = (_verifyTextField.text.length > 5) && [self validateInputWithString:_verifyTextField];
    
    if(validEmail && [_pwTextField.text isEqualToString:@""]) {
        [Queries updateEmail: username : _emailTextField.text];
        username = _emailTextField.text;
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor blackColor];
        _loginLabel.text = @"Save Successful";
        _emailTextField.text = @"";
    } else if ([_emailTextField.text isEqualToString:@""] && validPassword){
        [Queries updatePassword:username : _pwTextField.text];
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor blackColor];
        _loginLabel.text = @"Save Successful";
        _pwTextField.text = @"";
        _verifyTextField.text = @"";
    } else if (validPassword && validEmail) {
        [Queries updateEmail: username : _emailTextField.text];
        [Queries updatePassword:username : _pwTextField.text];
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor blackColor];
        _loginLabel.text = @"Save Successful";
        _pwTextField.text = @"";
        _verifyTextField.text = @"";
        _emailTextField.text = @"";
    } else if ((validPassword || [_pwTextField.text isEqualToString:@""]) && !validEmail){
    _loginLabel.font = [_loginLabel.font fontWithSize:14];
    _loginLabel.textColor = [UIColor redColor];
    _loginLabel.text = @"Email exists or is not valid";
    } else if (validEmail && !validPassword){
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor redColor];
        _loginLabel.text = @"Password is not valid";
    } else {
        _loginLabel.font = [_loginLabel.font fontWithSize:14];
        _loginLabel.textColor = [UIColor redColor];
        _loginLabel.text = @"Email/Password combination is not valid";
    }
}
- (IBAction)resignButton:(id)sender {
    [_emailTextField resignFirstResponder];
    [_pwTextField resignFirstResponder];
    [_verifyTextField resignFirstResponder];
    
    if(_emailTextField.text.length == 0) {
        _emailLabel.text = @"";
        
    }
    
    if(_pwTextField.text.length == 0 && _verifyTextField.text.length == 0) {
        _pwLengthLabel.text = @"";
        _pwLabel.text = @"";
    }
}
@end
