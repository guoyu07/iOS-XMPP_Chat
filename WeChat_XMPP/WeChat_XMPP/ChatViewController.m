//
//  ChatViewController.m
//  XMPPWeChat
//
//  Created by hebiao on 15/8/24.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import "ChatViewController.h"
#import "LoginViewController.h"
#import "XMPPChatManager.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if([[XMPPChatManager shareInstance] isLogin]){
        [[XMPPChatManager shareInstance] autoLogin];
        
    }else{
        [self loginAction];
    }
    
    
    
}

-(void)loginAction{
    
    LoginViewController *lvc=[[LoginViewController alloc] init];
    UINavigationController *nv=[[UINavigationController alloc] initWithRootViewController:lvc];
    [self presentViewController:nv animated:YES completion:^{
        
    }];
    
    
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
