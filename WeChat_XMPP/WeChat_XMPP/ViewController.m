//
//  ViewController.m
//  WeChat_XMPP
//
//  Created by hebiao on 15/8/24.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import "ViewController.h"

#import "ChatViewController.h"
#import "ListViewController.h"
#import "FindViewController.h"
#import "MeViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.s
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    ChatViewController *h1=[[ChatViewController alloc] init];
    UINavigationController *h11=[[UINavigationController alloc] initWithRootViewController:h1];
    
    UITabBarItem *t1=[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:1];
    h1.title=@"聊天";
    [h1 setTabBarItem:t1];
    
    
    
    ListViewController *h2=[[ListViewController alloc] init];
    UINavigationController *h22=[[UINavigationController alloc] initWithRootViewController:h2];
    
    UITabBarItem *t2=[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    h2.title=@"联系人";
    [h2 setTabBarItem:t2];
    
    
    FindViewController *h3=[[FindViewController alloc] init];
    UINavigationController *h33=[[UINavigationController alloc] initWithRootViewController:h3];
    
    
    UITabBarItem *t3=[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:3];
    h3.title=@"发现";
    [h3 setTabBarItem:t3];

    
    
    MeViewController *h4=[[MeViewController alloc] init];
    UINavigationController *h44=[[UINavigationController alloc] initWithRootViewController:h4];
    
    UITabBarItem *t4=[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:4];
    h4.title=@"发现";
    [h4 setTabBarItem:t4];
    
    
    NSArray *viewControllers = [NSArray arrayWithObjects:h11,h22,h33,h44, nil];
    
    tbviewController=[[UITabBarController alloc] init];
    tbviewController.viewControllers = viewControllers;
    tbviewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:tbviewController.view];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
