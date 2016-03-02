//
//  LoginViewController.h
//  XMPPWeChat
//
//  Created by hebiao on 15/8/24.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    UITextField *nameTextField,*passwordTextField;
    
}

@end
