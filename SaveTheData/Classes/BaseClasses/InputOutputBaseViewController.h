//
//  InputOutputBaseViewController.h
//  SaveTheData
//
//  Created by hooyking on 2020/4/15.
//  Copyright © 2020 hooyking. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputOutputBaseViewController : UIViewController

@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIButton *preserveButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;

@end

NS_ASSUME_NONNULL_END
