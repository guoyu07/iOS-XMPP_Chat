//
//  AddViewController.m
//  WeChat_XMPP
//
//  Created by hebiao on 15/8/25.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import "AddViewController.h"
#import "XMPPChatManager.h"
@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"添加好友";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    nameTextField=[[UITextField alloc] init];
    nameTextField.frame=CGRectMake(40, 64+40, 240, 30);
    nameTextField.placeholder=@"请输入用户名";
    nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    nameTextField.keyboardType=UIKeyboardTypeEmailAddress;
    
    [self.view addSubview:nameTextField];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addFriendAction)];
    
    
    
    
    
    
}
-(void)addFriendAction{
    
    [[XMPPChatManager shareInstance] addFriend:nameTextField.text];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
