//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Skylar Peterson on 10/17/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyView;
@end

@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateHistoryView];
}

- (void)updateHistoryView
{
    NSMutableAttributedString *historyString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSMutableAttributedString *string in self.history) {
        [string appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        [historyString appendAttributedString:string];
    }
    self.historyView.attributedText = historyString;
}

@end
