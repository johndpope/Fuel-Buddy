//
//  FuelListView.m
//  Fuel Buddy
//
//  Created by sxsasha on 4/24/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "FuelListView.h"
#import "FuelStation.h"
#import "FuelStationCell.h"


typedef enum : NSUInteger {
    ByDistance,
    ByPrice
} SortedBy;

@interface FuelListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *fuelTableView;

@property (weak, nonatomic) IBOutlet UIView *swipeView;
@property (weak, nonatomic) IBOutlet UIView *byDistanceArrow;
@property (weak, nonatomic) IBOutlet UIView *byPriceArrow;
@property (weak, nonatomic) IBOutlet UILabel *byDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *byPriceLabel;

@property (strong, nonatomic) NSArray <FuelStation *> *stations;
@property (assign, nonatomic) SortedBy sortedBy;
@end



static NSString *reusableIdentifier = @"FuelStationCell";

@implementation FuelListView

#pragma mark - InterfaceAPI

- (void)setupStations:(NSArray *)stations {
    _stations = stations;
    [self.fuelTableView reloadData];
}

#pragma mark - Main ovveriden methods

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupDelegate];
    [self setupSwipeAction];
    [self setupTableView];
    [self customizeSwipeView];
}

- (void)setupDelegate {
    self.fuelTableView.delegate = self;
    self.fuelTableView.dataSource = self;
}

- (void)setupTableView {
    //self.fuelTableView.allowsSelection = NO;
}

- (void)customizeSwipeView {
    self.swipeView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.swipeView.layer.shadowRadius = 3.0f;
    self.swipeView.layer.shadowOpacity = 0.7f;
    self.swipeView.layer.shadowOffset = CGSizeMake(0, 0);
    
    //shadow path
    CGFloat widthScreen = CGRectGetWidth([UIApplication sharedApplication].windows[0].frame);
    CGFloat offset = (widthScreen - 105.f) / 2.0f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, offset, 5));
    CGPathAddRect(path, NULL, CGRectMake(offset + 105.f, 0, widthScreen, 5));
    self.swipeView.layer.shadowPath = path;
}

#pragma mark - Animations

- (void)setupSwipeAction {
    self.sortedBy = ByDistance;
    
    UISwipeGestureRecognizer *swipeLeftRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeLeftRecogniser.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRightRecogniser = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeRightRecogniser.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:swipeLeftRecogniser];
    [self addGestureRecognizer:swipeRightRecogniser];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stations.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FuelStationCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    
    FuelStation *station = self.stations[indexPath.row];
    [cell setupWithStation:station];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate selectFuelStation:self.stations[indexPath.row]];
}

#pragma mark - Actions

- (void)swipeView:(UISwipeGestureRecognizer *)recogniser {
    if (recogniser.direction == UISwipeGestureRecognizerDirectionRight && self.sortedBy == ByDistance) {
        self.sortedBy = ByPrice;
        [self sortByPrice];
    }
    else if (recogniser.direction == UISwipeGestureRecognizerDirectionLeft && self.sortedBy == ByPrice) {
        self.sortedBy = ByDistance;
        [self sortByDistanse];
    }
}

- (void)sortByDistanse{
    self.byPriceLabel.textColor = [UIColor grayColor];
    [self.byPriceArrow setHidden:YES];
    self.byDistanceLabel.textColor = [UIColor whiteColor];
    [self.byDistanceArrow setHidden:NO];
}

- (void)sortByPrice{
    self.byPriceLabel.textColor = [UIColor whiteColor];
    [self.byPriceArrow setHidden:NO];
    self.byDistanceLabel.textColor = [UIColor grayColor];
    [self.byDistanceArrow setHidden:YES];
}


@end
