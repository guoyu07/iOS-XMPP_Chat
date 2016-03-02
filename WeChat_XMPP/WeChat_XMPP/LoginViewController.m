//
//  LoginViewController.m
//  XMPPWeChat
//
//  Created by hebiao on 15/8/24.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "XMPPChatManager.h"
#import "HeadFile.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"登录";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuc:) name:NOTICE_LOGIN_SUC_1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail:) name:NOTICE_LOGIN_FAIL_2 object:nil];
    
    
    UITableView *table=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    table.delegate=self;
    table.dataSource=self;
    table.separatorColor=[UIColor lightGrayColor];
    [self.view addSubview:table];
    table.userInteractionEnabled=NO;
    
    
    
    nameTextField=[[UITextField alloc] init];
    nameTextField.frame=CGRectMake(100, 64+40, 200, 30);
    nameTextField.placeholder=@"请输入用户名";
    nameTextField.keyboardType=UIKeyboardTypeEmailAddress;
    nameTextField.delegate=self;
    [self.view addSubview:nameTextField];
    
    passwordTextField=[[UITextField alloc] init];
     passwordTextField.placeholder=@"请输入密码";
    passwordTextField.secureTextEntry=YES;
    passwordTextField.returnKeyType=UIReturnKeyDone;
    passwordTextField.frame=CGRectMake(100, 64+40+44, 200, 30);
    passwordTextField.delegate=self;
    [self.view addSubview:passwordTextField];
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(rigsterAction)];
    
    
}
-(void)rigsterAction{
    
    RegisterViewController  *rvc=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==passwordTextField) {
        
        [self xmppLoginAction];
    }
    
    return YES;
}
-(void)xmppLoginAction{
    
    [[XMPPChatManager shareInstance] loginWith:nameTextField.text password:passwordTextField.text];
    
}

-(void)loginSuc:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)loginFail:(id)sender{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc] init];
    cell.textLabel.text= indexPath.row==0?@"用户名:":@"密   码:";
    return cell;
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
