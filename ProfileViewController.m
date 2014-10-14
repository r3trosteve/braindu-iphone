//
//  ProfileViewController.m
//  braindu-coredata
//
//  Created by Steven Schofield on 28/09/2014.
//  Copyright (c) 2014 Double Digital. All rights reserved.
//

#import <BrainduDataModel/BrainduDataModel.h>
#import "ProfileViewController.h"
#import "BUChartCell.h"
#import "BUItemListViewController.h"

typedef NS_ENUM(NSInteger, ProfileImagePickerAssociation) {
    ProfileImagePickerAssociationNone = 0,
    ProfileImagePickerAssociationAvatar,
    ProfileImagePickerAssociationBanner
};

@interface ProfileViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UIImage *pickedImage;

@property (strong, nonatomic) IBOutlet UIButton *avatarImageButton;
@property (strong, nonatomic) IBOutlet UIButton *bannerImageButton;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSMutableArray *charts;

@property (nonatomic, assign) ProfileImagePickerAssociation pickerAssociation;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        NSLog(@"%@", object);
        if (self.user != nil) {
            self.userFullnameLabel.text = self.user.username;
        }
        
        if (self.user.avatar != nil) {
            [self.user.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                self.userAvatarImage.image = image;
            }];
        }
        
        if (self.user.banner != nil) {
            [self.user.banner getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                self.userBannerImage.image = image;
            }];
            
        }
    }];
    
    self.bannerImageButton.hidden = YES;
    self.avatarImageButton.hidden = YES;
    self.doneButton.hidden = YES;
    
    if (self.user == [BUPUser currentUser]) {
        self.bannerImageButton.hidden = NO;
        self.bannerImageButton.alpha = 0.2;
        self.bannerImageButton.tintColor = [UIColor whiteColor];
        
        self.avatarImageButton.hidden = NO;
        self.doneButton.hidden = NO;
    }
    
    if ([BUPUser currentUser].location == nil) {
        [self loadLocation];
        NSLog(@"Get location");
    }
    
    
    _userChartTable.delegate = self;
    _userChartTable.dataSource = self;
    
    [self.user ensureCharts:^(NSMutableArray *charts) {
        self.charts = charts;
        [self.userChartTable reloadData];
    }];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setUserTotalChartsCountLabel];
    [self setUserTotalItemsCountLabel];
    
    self.userLocationLabel.text = self.user.location;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateCurrentUser {
    /*
    NSData *bannerImageData = UIImageJPEGRepresentation(self.pickedBannerImage, 0.75);
    PFFile *imageFile = [PFFile fileWithData:bannerImageData];
    self.user.banner = imageFile;
    [imageFile saveInBackground];
    
    [self.user saveInBackground];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"items"]) {
        UIButton *button = sender;
        CGPoint tableViewPoint = [self.userChartTable convertPoint:button.center fromView:button.superview];
        NSIndexPath *indexPath = [self.userChartTable indexPathForRowAtPoint:tableViewPoint];
        BUItemListViewController *itemListViewController = (BUItemListViewController *)segue.destinationViewController;
        itemListViewController.chart = self.charts[indexPath.row];
    }
}

#pragma mark - ImagePicker Delegates

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

- (void)setPickedImage:(UIImage *)pickedImage
{
     _pickedImage = pickedImage;
    
    if (!pickedImage) {
        return;
    }
    
    if (self.pickerAssociation == ProfileImagePickerAssociationAvatar) {
        [self.userAvatarImage setImage:pickedImage];
        
        self.avatarImageButton.alpha = 0.4;
        
        NSData *imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        self.user.avatar = imageFile;
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Uploaded avatar Image");
            } else {
                NSLog(@"Error saving Image");
            }
        }];
        
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Saved User");
            } else {
                NSLog(@"Error saving User");
            }
        }];
         // Upload or whatever, set to model.avatarImage
        
        
    } else if (self.pickerAssociation == ProfileImagePickerAssociationBanner) {
        [self.userBannerImage setImage:pickedImage];
        
        self.bannerImageButton.alpha = 0.4;
        
        NSData *imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
        PFFile *imageFile = [PFFile fileWithData:imageData];
        self.user.banner = imageFile;
        [imageFile saveInBackground];
        
        [self.user saveInBackground];
        // Upload or whatever, set to model.bannerImage
    }
    
    self.pickerAssociation = ProfileImagePickerAssociationNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.charts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BUChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    BUPChart *chart = self.charts[indexPath.row];
    [cell configureCellForChart:chart];
    
    return cell;
}


#pragma mark - Convenience Methods

- (void) setUserTotalChartsCountLabel {
    int chartsCount = [self.user.charts count];
    self.userTotalChartsCountLabel.text = [NSString stringWithFormat:@"%d", chartsCount];
}

- (void) setUserTotalItemsCountLabel {
    int itemsCount = [self.user.items count];
    self.userTotalItemsCountLabel.text = [NSString stringWithFormat:@"%d", itemsCount];
}

#pragma mark - Location

- (void)loadLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
        
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        self.locationManager.desiredAccuracy = 1000;
        
        [self.locationManager startUpdatingLocation];
        
        
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    NSLog(@"%@", location);
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"%@", placemark);
        self.user.location = placemark.name;
        NSLog(@"%@", self.user.location);
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"User Saved with Location");
            }
        }];
        
    }];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
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

- (IBAction)didPressBannerUpload:(id)sender {
    self.pickerAssociation = ProfileImagePickerAssociationBanner;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}

- (IBAction)didPressAvaterUpload:(id)sender {
    self.pickerAssociation = ProfileImagePickerAssociationAvatar;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}

@end
