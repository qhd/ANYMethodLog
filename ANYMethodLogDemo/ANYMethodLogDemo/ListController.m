//
//  ListController.m
//  ANYMethodLogDemo
//
//  Created by qiuhaodong on 2017/1/18.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/ANYMethodLog.git
//

#import "ListController.h"
#import "DetailController.h"

@interface ListController ()

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeBackground];
}

- (void)changeBackground {
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickEnterDetailButton:(id)sender {
    [self.navigationController pushViewController:[[DetailController alloc] init] animated:YES];
}

@end
