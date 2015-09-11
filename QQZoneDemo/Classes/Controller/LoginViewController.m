//
//  LoginViewController.m
//  QQZoneDemo
//
//  Created by Xiang on 15/9/11.
//  Copyright (c) 2015年 周想. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIView *loginView;

/** 登录指示器 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *remPassword;

@property (weak, nonatomic) IBOutlet UIButton *autoLogin;

/** 登录 */
- (IBAction)login;

/** 记住密码 */
- (IBAction)remPassword:(UIButton *)sender;

/** 自动登录 */
- (IBAction)autoLogin:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/** 登录 */
- (IBAction)login {
    // 0.退出键盘
    [self.view endEditing:YES];
    
    // 1.判断账号密码是否为空
    NSString *account = self.accountField.text;
    NSString *password = self.passwordField.text;
    
    if (account.length ==0 || password.length ==0) {
        // 提示用户帐号或密码为空
        [self showLoginError:@"帐号或密码不能为空"];
        return;
    }
    
    // 2.判断帐号密码是否正确(模拟登录延时2秒)
    [self.activityIndicator startAnimating];
    CGFloat duration = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 判断
        if ([account isEqualToString:@"123"] && [password isEqualToString:@"123"]) {
            // 帐号密码正确，登陆成功
        } else {
            // 帐号密码不正确，提示用户登录失败
            [self showLoginError:@"帐号或密码错误"];
        }
        [self.activityIndicator stopAnimating];
    });
}

- (IBAction)remPassword:(UIButton *)sender {
    // 改变按钮选中状态
    self.remPassword.selected = !self.remPassword.isSelected;
    
    if (self.remPassword.selected == NO) {
        self.autoLogin.selected = NO;
    }
}

- (IBAction)autoLogin:(UIButton *)sender {
    // 改变按钮选中状态
    self.autoLogin.selected = !self.autoLogin.isSelected;
    
    if (self.autoLogin.selected == YES) {
        self.remPassword.selected = YES;
    }
}

/** 登录失败提示 */
- (void)showLoginError:(NSString *)error {
    // 1.弹出弹窗提示用户登录失败
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:error preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    // 2.给登录界面添加一个抖动动画
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnimation.values = @[@-8, @0, @8, @0];
    shakeAnimation.duration = 0.1;
    shakeAnimation.repeatCount = 4;
    [self.loginView.layer addAnimation:shakeAnimation forKey:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.accountField == textField) {
        [self.passwordField becomeFirstResponder];
    } else if (self.passwordField == textField) {
        [self login];
    }
    
    return YES;
}

@end
