//
//  ListViewController.m
//  VinTest
//
//  Created by kingpoint on 14-7-23.
//  Copyright (c) 2014年 kingpoint. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *list;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    list = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 5; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:i];
        for (int j = 1; j <= i + 5; j ++) {
            [array addObject:[NSString stringWithFormat:@"%d类别%d", i, j]];
        }
        [list addObject:array];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [list objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *array = [list objectAtIndex:indexPath.section];
    NSString *str = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    label.text = [NSString stringWithFormat:@"%d类别", section + 1];
    return label;
}

@end
