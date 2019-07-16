//
//  JSDSearchViewModel.m
//  AccountCheat
//
//  Created by Jersey on 2019/7/16.
//  Copyright © 2019 Jersey. All rights reserved.
//

#import "JSDSearchViewModel.h"

#import "JSDHomeModel.h"

@implementation JSDSearchViewModel

- (void)executeSearchWithText:(NSString *)text type:(NSString *)type complection:(void (^)(void))complection {
    
    _searchText = text;
    _type = type;
    
    NSMutableArray* templateArray = [[NSMutableArray alloc] init];
    NSLog(@"%ld", self.listArray.count);
    for (JSDItemListViewModel* listModel in self.listArray) {
        for (JSDItemListModel* itemModel in listModel.itemList) {
            if ([itemModel.name localizedCaseInsensitiveContainsString:text]) {
                [templateArray addObject:itemModel];
                continue;
            } else if ([itemModel.account localizedCaseInsensitiveContainsString:text]) {
                [templateArray addObject:itemModel];
                continue;
            } else if ([itemModel.password localizedCaseInsensitiveContainsString:text]) {
                [templateArray addObject:itemModel];
                continue;
            } else if ([itemModel.type localizedCaseInsensitiveContainsString:text]) {
                [templateArray addObject:itemModel];
                continue;
            } else if ([itemModel.remark localizedCaseInsensitiveContainsString:text]) {
                [templateArray addObject:itemModel];
                continue;
            }
        }
    }
    self.resultArray = templateArray;
    complection ? complection () : NULL;
}

//- (NSMutableArray<JSDItemListModel *> *)listArray {
//
//    if (!_listArray) {
//
//
//        _listArray = [[JSDItemListViewModel alloc] init].itemList;
//    }
//    return _listArray;
//}

- (NSMutableArray<JSDItemListModel *> *)listArray {
    
    if (!_listArray) {
        NSArray* typeArray = [[JSDHomeViewModel alloc] init].typeArray;
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        for (JSDHomeModel* model in typeArray) {
            JSDItemListViewModel* listModel = [[JSDItemListViewModel alloc] init];
            listModel.type = model.title;
            if (listModel.itemList.count) {
                [tempArray addObject:listModel];
            }
        }
        _listArray = tempArray;
    }
    return _listArray;
}

@end
