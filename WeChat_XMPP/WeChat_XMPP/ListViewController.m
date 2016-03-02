//
//  ListViewController.m
//  XMPPWeChat
//
//  Created by hebiao on 15/8/24.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import "ListViewController.h"

#import "XMPPChatManager.h"
#import "AddViewController.h"
#import "XMPPFramework.h"

#import "JSQChatViewController.h"


@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
       self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addFriendAction)];
    
    
    
    
    NSManagedObjectContext *context=[[XMPPChatManager shareInstance] rosterContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSSortDescriptor *sd1=[NSSortDescriptor sortDescriptorWithKey:@"sectionNum" ascending:YES];
    NSSortDescriptor *sd2=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setSortDescriptors:@[sd1,sd2]];
 
    fetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"sectionNum" cacheName:nil];
    fetchedResultsController.delegate=self;
    [fetchedResultsController performFetch:nil];
    
    
    
    
    table=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    table.delegate=self;
    table.dataSource=self;
    table.separatorColor=[UIColor lightGrayColor];
    [self.view addSubview:table];
    
    
}



-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    
    [table reloadData];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [fetchedResultsController sections].count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr=[fetchedResultsController sections];
    
    
    id<NSFetchedResultsSectionInfo>  secetionInfo=arr[section];
    
    return secetionInfo.numberOfObjects;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSArray *arr=[fetchedResultsController sections];
    
    
    id<NSFetchedResultsSectionInfo>  secetionInfo=arr[section];
    
    
    return secetionInfo.name;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc] init];
    
    XMPPUserCoreDataStorageObject *user=[fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text=user.jid.user;
    cell.detailTextLabel.text=@"状态null";
  
    
    if (user.photo!=nil) {
        cell.imageView.image=user.photo;
    }else{
        
        NSData *phdata=[[[XMPPChatManager shareInstance] vatarModule] photoDataForJID:user.jid];
        if (phdata!=nil) {
            cell.imageView.image=[UIImage imageWithData:phdata];
        }else{
            cell.imageView.image=[UIImage imageNamed:@"AppIcon"];
        }
    }
    
 
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMPPUserCoreDataStorageObject *user=[fetchedResultsController objectAtIndexPath:indexPath];

    
    JSQChatViewController *jsc=[[JSQChatViewController alloc] init];
    jsc.hidesBottomBarWhenPushed=YES;
    jsc.currentUser=user;
    [self.navigationController pushViewController:jsc animated:YES];
    
    
}
-(void)addFriendAction{
    
    AddViewController *avc=[[AddViewController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
    
    
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
