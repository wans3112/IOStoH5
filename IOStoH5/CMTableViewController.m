//
//  CMTableViewController.m
//  IOStoH5
//
//  Created by water on 14-9-3.
//  Copyright (c) 2014年 water. All rights reserved.
//

#import "CMTableViewController.h"
#import "CMAlertView.h"
#import "ViewController.h"
@interface CMTableViewController ()

@end

@implementation CMTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    if (indexPath .row == 0) {
        cell.textLabel.text = @"在线测试";
    }else if(indexPath .row == 1){
        cell.textLabel.text = @"本地测试";
    }else if(indexPath .row == 2){
        cell.textLabel.text = @"输入网址";
    }
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath .row == 0) {
        
        ViewController *controller = [[ViewController alloc]init];
        controller.onlineUrl = @"http://www.elearning123.com/app_base/apph5/main.html";
        [controller setTitle:@"在线测试"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if(indexPath .row == 1){
        ViewController *controller = [[ViewController alloc]init];
        [controller setTitle:@"本地测试"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(indexPath .row == 2){
        [self inputAdrress];
    }
}

- (void)inputAdrress{
    CMAlertView *alert = [[CMAlertView alloc]initWithPlaceholder:@"请输入网址！" cancelButtonTitle:@"取消" comfirmButtonTitle:@"确定" completionBlock:^(NSUInteger buttonIndex, CMAlertView *alertView) {
        if (buttonIndex != [alertView cancleButtonInde]) {
            NSString *url = alertView.textfield.text;
            
            [self writeData:url key:@"url"];
            ViewController *controller = [[ViewController alloc]init];
            controller.onlineUrl = url;
            [controller setTitle:@"在线测试"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    [alert showInView:self.navigationController.view];
}

- (BOOL)writeData:(NSString *)value key:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:value forKey:key];
    return [ud synchronize];
}

- (NSString *)readData:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    return [ud objectForKey:key];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
