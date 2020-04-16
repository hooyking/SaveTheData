//
//  InputOutputBaseViewController.m
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import "InputOutputBaseViewController.h"

#define kScreenH  [UIScreen mainScreen].bounds.size.height
#define kScreenW  [UIScreen mainScreen].bounds.size.width

@interface InputOutputBaseViewController ()<UITextFieldDelegate>

@end

@implementation InputOutputBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.showButton];
    [self.view addSubview:self.preserveButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, kScreenW, 30)];
        _label.text = @"上边输入";
        _label.font = [UIFont systemFontOfSize:25];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kScreenW/6, 100, kScreenW*2/3, 40)];
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_showButton setTitle:@"获取刚保存的" forState:UIControlStateNormal];
        _showButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _showButton.frame = CGRectMake(40, 180, 200, 40);
        [_showButton addTarget:self action:@selector(showButtonClicked) forControlEvents:UIControlEventTouchDown];
    }
    return _showButton;
}

- (UIButton *)preserveButton {
    if (!_preserveButton) {
        _preserveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_preserveButton setTitle:@"保存" forState:UIControlStateNormal];
        _preserveButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _preserveButton.frame = CGRectMake(250, 180, 40, 40);
        [_preserveButton addTarget:self action:@selector(preserveButtonClicked) forControlEvents:UIControlEventTouchDown];
    }
    return _preserveButton;
}

- (void)preserveButtonClicked {
    [self.textField resignFirstResponder];
}

- (void)showButtonClicked {
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

@end
