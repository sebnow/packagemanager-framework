/*
 * Copyright (c) 2008 Sebastian Nowicki <sebnow@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

@class PMPackage;

@protocol PMTransactionDelegate;

@interface PMTransaction : NSObject {
	NSMutableArray *_removeTargets;
	NSMutableArray *_syncTargets;
	id<PMTransactionDelegate> _delegate;
	int _flags;
}

@property (nonatomic, retain) id<PMTransactionDelegate> delegate;
@property (nonatomic, assign) BOOL force;
@property (nonatomic, assign, getter=isRecursive) BOOL recursive;
@property (nonatomic, assign) BOOL cascade;
// Only install the targets that are not already installed and up-to-date.
@property (nonatomic, assign) BOOL neededOnly;
@property (nonatomic, assign) BOOL downloadOnly;

- (id) init;
- (void) synchronizePackage:(PMPackage *)thePackage;
- (void) removePackage:(PMPackage *)thePackage;
- (void) commit;

@end

@protocol PMTransactionDelegate
@optional
- (BOOL) transaction:(PMTransaction *)aTransaction shouldRemoveCorruptPackageArchive:(NSString *)filename;
@end
