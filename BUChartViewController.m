//
//  BUNewChartViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 26/08/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import "BUChartViewController.h"
#import "BUPChart.h"
#import "BUPUser.h"

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
    
    if (self.chart.image != nil) {
        [self.chart.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            self.chartImage.image = image;
        }];
        
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertNewChart {
    BUPChart *chart = [BUPChart object];
    chart.owner = [BUPUser currentUser];
    chart.title = self.titleField.text;
    chart.body = self.bodyTextArea.text;
    
    NSData *imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    // TODO Change image name
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    chart.image = imageFile;
    [imageFile saveInBackground];
    [chart saveInBackground];
    
    [[BUPUser currentUser] ensureCharts:^(NSMutableArray *charts) {
        [charts addObject:chart];
        
        [self dissmissSelf];
    }];
}

- (void)updateChart {
    self.chart.title = self.titleField.text;
    self.chart.body = self.bodyTextArea.text;
    
    NSData *imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    // TODO Change image name
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    self.chart.image = imageFile;
    [imageFile saveInBackground];
    
    [self.chart saveInBackground];
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
        [self dissmissSelf];
    } else {
        [self insertNewChart];
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
