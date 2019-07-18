//
//  JSDBaseViewController.m
//  MaterialColor
//
//  Created by Jersey on 2019/7/8.
//  Copyright © 2019 Jersey. All rights reserved.
//

#import "JSDBaseViewController.h"

@interface JSDBaseViewController ()

@end

@implementation JSDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
}

- (void)setupNavigation {

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(didTapBack:)];
    UIImage *backImage = [UIImage imageNamed:@"back"];
    backButton.image = backImage;
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)didTapBack:(id)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
