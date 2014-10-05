//
//  itemReadViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 04/10/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "ItemReadViewController.h"
#import "BUPUser.h"
#import "BUPItem.h"
#import "BUPItemComment.h"


@interface ItemReadViewController ()

@end

@implementation ItemReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.item != nil) {
        self.itemTitleLabel.text = self.item.title;
        self.noteTextArea.text = self.item.note;
    }
    
    if (self.item.image != nil) {
        [self.item.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            self.itemImageView.image = image;
        }];
    }
    
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(keyboardWasShown)
                               name:UIKeyboardDidShowNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(keyboardWillHide)
                               name:UIKeyboardWillHideNotification
                             object:nil];
    
    _commentsTableView.delegate = self;
    _commentsTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    CGFloat width = self.view.frame.size.width;
    CGFloat padding = 20.0;
    CGFloat titleHeight = 44.0;
    CGFloat notesHeight = self.noteTextArea.frame.size.height + (padding * 2) + titleHeight;
    CGFloat commentsHeight = self.commentsTableView.frame.size.height + (padding * 2) + titleHeight;
    CGFloat scrollViewHeight = notesHeight + commentsHeight;
    _scrollView.contentSize = CGSizeMake(width, scrollViewHeight);
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}


- (void) keyboardWasShown {
    
    [UIView animateWithDuration:0.2 animations:^{
         _commentTextField.frame = CGRectMake(0, 196, 320, 48);
    } completion:^(BOOL finished) {
        NSLog(@"Keyboard Shown");
    }];
   
}

- (void) keyboardWillHide {
    [UIView animateWithDuration:0.5 animations:^{
        _commentTextField.frame = CGRectMake(0, 456, 320, 48);
    } completion:^(BOOL finished) {
        NSLog(@"Keyboard Shown");
    }];
}

#pragma mark - TextField Delegates

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.commentTextField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

@end
