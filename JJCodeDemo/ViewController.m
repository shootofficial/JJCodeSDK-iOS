//
//  ViewController.m
//  JJCodeDemo
//
//  Created by Shoot on 2021/11/10.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)verify:(id)sender {
    NSString* phoneNumber = _phoneNumberTextField.text;
    if (phoneNumber == nil || phoneNumber.length <= 0) {
        [self showAler:@"Fail" :@"请输入需要验证的手机号码"];
        return;
    }
    
    [JJCode verify:phoneNumber success:^(NSString * _Nonnull mobile, NSString * _Nonnull token) {
        NSString* info = [NSString stringWithFormat:@"success mobile: %@, token: %@", mobile, token];
        [self showAler:@"Success" :info];
    } fail:^(NSInteger code, NSString * _Nonnull message) {
        NSString* errorInfo = [NSString stringWithFormat:@"fail code: %ld, message: %@", code, message];
        [self showAler:@"Fail" :errorInfo];
    }];
}

- (IBAction)checkWx:(id)sender {
    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
        NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
    }];
}

- (void) showAler:(NSString*)title :(NSString*)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //button click event
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
