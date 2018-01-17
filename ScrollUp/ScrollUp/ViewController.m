//
//  ViewController.m
//  ScrollUp
//
//  Created by 김진선 on 2018. 1. 16..
//  Copyright © 2018년 JinseonKim. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat previousOffset;
//You use 'previousOffset' to compare the previous scroll position with the current scroll position
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"cellID"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.maxHeight = 50;
    self.minHeight = 0;
    self.headerHeight.constant = self.maxHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.5 animations:^{
        //  You can use 'scrollDiff' the scrollDiff variable defined above to manipulate its height.
        CGFloat scrollDiff = scrollView.contentOffset.y - self.previousOffset;
        
        CGFloat absoluteTop = 0;
        CGFloat absoluteBottom = scrollView.contentSize.height - scrollView.frame.size.height;
        
        BOOL isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop;
        BOOL isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom;
        
        if ([self canAnimateHeader:scrollView]) {
            
            // You use a newHeight variable to determine the what the height of our header should be depending on the direction the user has scrolled.
            CGFloat newHeight = self.headerHeight.constant;
            
            // You don’t want the header to grow or shrink past our min/max values, you need to do a little bit of math to make sure you stay within your predefined limits.
            if (isScrollingDown) {
                newHeight = MAX(self.minHeight, self.headerHeight.constant - fabs(scrollDiff));
            } else if (isScrollingUp) {
                newHeight = MIN(self.maxHeight, self.headerHeight.constant + fabs(scrollDiff));
            }
            
            // Header needs to animate
            // Simply update that if statement to set the current scroll position to the previous scroll position.
            if (newHeight != self.headerHeight.constant) {
                self.headerHeight.constant = newHeight;
                [self updateHeader];
                [self setScrollPosition:self.previousOffset];
            }
            self.previousOffset = scrollView.contentOffset.y;
            
        }
        
    }];
}

// To prevent the header from collapsing in unideal situations, we need to check that there is still room to scroll even when the header is collapsed.
- (BOOL)canAnimateHeader:(UIScrollView *)scrollView {
    
    CGFloat scrollViewMaxHeight = scrollView.frame.size.height + self.headerHeight.constant - self.minHeight;
    
    return scrollView.contentSize.height > scrollViewMaxHeight;
}

- (void)setScrollPosition:(CGFloat)position {
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, position);
}

- (void)updateHeader {
    CGFloat range = self.maxHeight - self.minHeight;
    CGFloat openAmout = self.headerHeight.constant - self.minHeight;
    CGFloat percentage = openAmout / range;
    
//    self.titleTopConstraint.constant = -openAmount + 10
//    self.logoImageView.alpha = percentage
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // scrolling has stopped
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        //scrolling has stopped
    }
}

- (void)scrollingViewDidStopScrolling {
    // Once we have the midpoint, we can check to see if the header height is greater than the midpoint and if so expand the header, otherwise collapse it.
    CGFloat range = self.maxHeight - self.minHeight;
    CGFloat midPoint = self.minHeight + (range / 2);
    
    if (self.headerHeight.constant > midPoint) {
        
    }
}

- (void)expandHeader {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.headerHeight.constant = self.minHeight;
        [self updateHeader];
        [self.view layoutIfNeeded];
    }];
}

- (void)collapseHeader {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.headerHeight.constant = self.maxHeight;
        [self updateHeader];
        [self.view layoutIfNeeded];
    }];
}

@end
