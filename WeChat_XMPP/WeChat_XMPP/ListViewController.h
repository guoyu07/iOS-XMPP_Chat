//
//  ListViewController.h
//  XMPPWeChat
//
//  Created by hebiao on 15/8/24.
//  Copyright (c) 2015年 Hebiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface ListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>{
    
    NSFetchedResultsController *fetchedResultsController;
    UITableView *table;
    
}

@end
