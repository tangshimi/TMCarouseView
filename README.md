# TMCarouseView

##basic use
    CGRect rect = [UIScreen mainScreen].bounds;
    TMCarouselView *view = [[TMCarouselView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), 200)];
    view.switchingTime = 1;
    
    NSArray *array = @[ @"http://attach.bbs.miui.com/forum/201206/06/2226336d6nxnnfxldyxhed.jpg", @"http://imgstore.cdn.sogou.com/app/a/100540002/714860.jpg" , @"http://cdn.duitang.com/uploads/item/201112/27/20111227143751_TtLkL.jpg" ];
    
    [view setImagesArray:array];
    
    view.clickBlock = ^(NSInteger index) {
        
        NSLog(@"%@", @(index));
    };
    
    [self.view addSubview:view];

![](https://s3.amazonaws.com/f.cl.ly/items/2x3O0A2H090c1L0m200p/Carouse.gif?v=e9aadade)

##CocoaPods

pod 'TMCarouseView'