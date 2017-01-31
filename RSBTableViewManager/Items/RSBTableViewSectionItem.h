//Copyright (c) 2015 RSBTableViewManager
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "RSBTableViewSectionItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * @discussion This class can be used as base class for any section item.
 */
@interface RSBTableViewSectionItem : NSObject <RSBTableViewSectionItemProtocol>

///Use this method for creating section item with cell items.
- (instancetype)initWithCellItems:(NSArray<id<RSBTableViewCellItemProtocol>> *)cellItems;

///Array of cell items managed by this section item.
@property (nonatomic) NSArray<id<RSBTableViewCellItemProtocol>> *cellItems;
/*!
 * @discussion Set this property if you need to show standard header view in section with title.
 * @warning You still need to set height for header view. In this class it's set equals 22pt. Subclass and oveeride for different value.
 */
@property (nonatomic) NSString *headerTitle;
/*!
 * @discussion Set this property if you need to show standard footer view in section with title.
 * @warning You still need to set height for footer view. In this class it's set equals 22pt. Subclass and oveeride for different value.
 */
@property (nonatomic) NSString *footerTitle;

@end

NS_ASSUME_NONNULL_END
