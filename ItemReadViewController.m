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
#import "BUPItemVote.h"
#import "ItemCommentCell.h"


@interface ItemReadViewController ()

@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;

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
    
    [self.item ensureItemComments:^(NSMutableArray *itemComments) {
        [self.commentsTableView reloadData];
    }];
    
    
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

- (void) viewWillAppear:(BOOL)animated {
    self.voteCountLabel.text = [NSString stringWithFormat:@"%@ Votes", self.item.voteCount];
    
    BUPUser *user = [BUPUser currentUser];
    PFRelation *relation = [user relationForKey:@"votes"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Items voted: %@", objects);
            for (BUPItem *item in objects) {
                if([item.objectId isEqualToString:self.item.objectId]){
                    [self.voteButton setSelected:YES];
                    break;
                }
            }
        }
    }];
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

- (void)insertNewItemComment {
    
    BUPItemComment *itemComment = [BUPItemComment object];
    itemComment.owner = [BUPUser currentUser];
    itemComment.text = self.commentTextField.text;
    itemComment.item = self.item;
    
    [itemComment saveInBackground];
    
    [self.item ensureItemComments:^(NSMutableArray *itemComments) {
        self.commentTextField.text = @"";
        [itemComments addObject:itemComment];
        [self.commentsTableView reloadData];
    }];
}

- (void)insertNewItemVote {
    BUPUser *user = [BUPUser currentUser];
    PFRelation *relation = [user relationForKey:@"votes"];
    [relation addObject:self.item];
    [user saveInBackground];

}

- (void)removeItemVote {
    BUPUser *user = [BUPUser currentUser];
    PFRelation *relation = [user relationForKey:@"votes"];
    [relation removeObject:self.item];
    [user saveInBackground];
}

- (void)incrementVotesCountForItem {
    [self.item incrementKey:@"voteCount" byAmount:[NSNumber numberWithInt:1]];
    [self.item saveInBackground];
}

- (void)decrementVotesCountForItem {
    [self.item incrementKey:@"voteCount" byAmount:[NSNumber numberWithInt:-1]];
    [self.item saveInBackground];
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
    return self.item.itemComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    BUPItemComment *itemComment = self.item.itemComments[indexPath.row];
    [cell configureCellForItemComment:itemComment];

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
    
    [self insertNewItemComment];
    
    [textField resignFirstResponder];
    
    return NO;
}

- (IBAction)voteWasPressed:(id)sender {
    
    if (!self.voteButton.isSelected) {
        [self incrementVotesCountForItem];
        [self insertNewItemVote];
        [self.voteButton setSelected:YES];
        self.voteCountLabel.text = [NSString stringWithFormat:@"%@ Votes", self.item.voteCount];
        
    } else if (self.voteButton.isSelected) {
        [self decrementVotesCountForItem];
        [self removeItemVote];
        [self.voteButton setSelected:NO];
        self.voteCountLabel.text = [NSString stringWithFormat:@"%@ Votes", self.item.voteCount];
    }
    
}



@end
