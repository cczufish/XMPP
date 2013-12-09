//
//  LoginViewController.m
//  LXFXMPPDemo
//
//  Created by iObitLXF on 4/25/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASSWORD];
    NSString *server = [defaults stringForKey:SERVER];

    if ([userId length]>0) {
        self.textFieldName.text = userId;
    }
    if ([pass length]>0) {
        self.textFieldPassword.text = pass;
    }

    if ([server length]>0) {
        self.textFieldServer.text = server;
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   
    [self setTextFieldName:nil];
    [self setTextFieldPassword:nil];
    [self setTextFieldServer:nil];
    [super viewDidUnload];
}
- (IBAction)LoginButton:(id)sender {
    
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults stringForKey:USERID];
    
    NSString *name =userId;
    if (![self.textFieldName.text isEqualToString:userId]) {
        name = [NSString stringWithFormat:@"%@@jarodxitekiimac",self.textFieldName.text];
    }
   
    NSString *pas = self.textFieldPassword.text;
    NSString *server = self.textFieldServer.text;
    if ([server length]==0) {
        server = @"jarodxitekiimac";
    }
    
    if ([self validateWithUser:name andPass:pas andServer:server]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:name forKey:USERID];
        [defaults setObject:pas forKey:PASSWORD];
        [defaults setObject:server forKey:SERVER];
        //保存
        [defaults synchronize];
        
        [self dismissModalViewControllerAnimated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名，密码和服务器" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (IBAction)closeButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)validateWithUser:(NSString *)userText andPass:(NSString *)passText andServer:(NSString *)serverText{
    
    if (userText.length > 0 && passText.length > 0 && serverText.length > 0) {
        return YES;
    }
    
    return NO;
}
@end
