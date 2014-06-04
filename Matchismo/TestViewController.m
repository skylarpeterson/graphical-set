//
//  TestViewController.m
//  Graphical Set
//
//  Created by Skylar Peterson on 10/27/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "TestViewController.h"
#import "SetCarView.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet SetCarView *setCardView;
@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.setCardView.sign = 3;
    self.setCardView.numSymbols = 3;
    self.setCardView.color = [UIColor blueColor];
    self.setCardView.shading = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
