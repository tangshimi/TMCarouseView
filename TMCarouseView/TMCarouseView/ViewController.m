//
//  ViewController.m
//  TMCarouseView
//
//  Created by tangshimi on 6/20/16.
//  Copyright © 2016 medtree. All rights reserved.
//

#import "ViewController.h"
#import "TMCarouselView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    TMCarouselView *view = [[TMCarouselView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), 200)];
    view.switchingTime = 1;
    
    NSArray *array = @[ @"http://attach.bbs.miui.com/forum/201206/06/2226336d6nxnnfxldyxhed.jpg", @"http://imgstore.cdn.sogou.com/app/a/100540002/714860.jpg" , @"http://cdn.duitang.com/uploads/item/201112/27/20111227143751_TtLkL.jpg"  ];
    
    [view setImagesArray:array];
    
    view.clickBlock = ^(NSInteger index) {
        
        NSLog(@"%@", @(index));
    };
    
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
