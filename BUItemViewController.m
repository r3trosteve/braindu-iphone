//
//  BUItemViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "BUItemViewController.h"
#import "BUPItem.h"
#import "BUPChart.h"
#import "BUPUser.h"
#import "CoreDataStack.h"

@interface BUItemViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextArea;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (nonatomic, strong) UIImage *pickedImage;
@property (strong, nonatomic) IBOutlet UILabel *addImageLabel;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;


@end

@implementation BUItemViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Core Data actions

-(void)dissmissSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertNewItem {
    BUPItem *item = [BUPItem object];
    item.owner = [BUPUser currentUser];
    item.chart = self.chart;
    item.title = self.titleField.text;
    item.note = self.noteTextArea.text;
    
    NSData *imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    item.image = imageFile;
    
    item.chart = self.chart;
    [imageFile saveInBackground];
    [item saveInBackground];
    
    [self.chart ensureItems:^(NSMutableArray *items) {
        [items addObject:item];
        
        [self dissmissSelf];
    }];
}

- (void)updateItem {
    self.item.title = self.titleField.text;
    self.item.note = self.noteTextArea.text;
    
    NSData *imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.item.image = imageFile;
    [imageFile saveInBackground];
    
    [self.item saveInBackground];
}

#pragma mark - Image Picker Delegate

- (void)promptForSource {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"camera", @"photo roll", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self promptForCamera];
    } else {
        [self promptForPhotoRoll];
    }
}

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    
    if (pickedImage != nil) {
        [self.itemImage setImage:pickedImage];
        self.titleField.textColor = [UIColor whiteColor];
        self.imageButton.tintColor = [UIColor whiteColor];
        self.imageButton.alpha = 0.4;
        self.addImageLabel.alpha = 0.0;
    }
}

- (IBAction)doneWasPressed:(id)sender {
    if (self.item != nil) {
        [self updateItem];
        [self dissmissSelf];
    } else {
        [self insertNewItem];
    }
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dissmissSelf];
}

- (IBAction)imageButtonWasPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}


@end
