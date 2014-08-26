//
//  BUNewChartViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "BUChartViewController.h"
#import "BUChart.h"
#import "CoreDataStack.h"

@interface BUChartViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextArea;
@property (weak, nonatomic) IBOutlet UIImageView *chartImage;
@property (nonatomic, strong) UIImage *pickedImage;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UILabel *addImageLabel;


@end

@implementation BUChartViewController

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
    
    if (self.chart != nil) {
        self.titleField.text = self.chart.title;
        self.bodyTextArea.text = self.chart.body;
    }
    
    if (self.chart.imageData != nil) {
        
        self.chartImage.image = [UIImage imageWithData:self.chart.imageData];
        self.titleField.textColor = [UIColor whiteColor];
        self.imageButton.tintColor = [UIColor whiteColor];
        self.imageButton.alpha = 0.2;
        self.addImageLabel.alpha = 0.0;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.titleField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)dissmissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)insertNewChart {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    BUChart *chart = [NSEntityDescription insertNewObjectForEntityForName:@"BUChart" inManagedObjectContext:coreDataStack.managedObjectContext];
    chart.title = self.titleField.text;
    chart.body = self.bodyTextArea.text;
    chart.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    chart.is_public = YES;
    [coreDataStack saveContext];
}

- (void)updateChart {
    self.chart.title = self.titleField.text;
    self.chart.body = self.bodyTextArea.text;
    self.chart.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

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
        [self.chartImage setImage:pickedImage];
        self.titleField.textColor = [UIColor whiteColor];
        self.imageButton.tintColor = [UIColor whiteColor];
        self.imageButton.alpha = 0.4;
        self.addImageLabel.alpha = 0.0;
    }
}

- (IBAction)doneWasPressed:(id)sender {
    if (self.chart != nil) {
        [self updateChart];
    } else {
        [self insertNewChart];
    }
    
    [self dissmissSelf];
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
