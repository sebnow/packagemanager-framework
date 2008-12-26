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

@class PMDatabase;

@interface PMPackage : NSObject {
	struct __pmpkg_t *_package;
	PMDatabase *_database;
	NSString *_filename;
	NSString *_name;
	NSString *_version;
	NSURL *_url;
	NSString *_description;
	NSString *_packager;
	NSNumber *_size;
}

- (NSString *)name;
- (NSString *)version;
- (NSURL *)url;
- (PMDatabase *)database;
- (NSString *)packager;
- (NSNumber *)size;
- (NSString *)filename;
- (BOOL) isInstalled;

- (id) initWithName:(NSString *)aName fromDatabase:(PMDatabase *)theDatabase;

/** Initializes a package object with the package data from the location
 specified by aURL.

 If the location refers to a remote file, it will first be downloaded. The
 download location will be one of the cache directories, or if none are
 available, in the temporary directory.

 Once the file has been downloaded the procedure is identical to
 PMPackage::initWithContentsOfFile:

 @param theURL url to the package file from which to read data
 */
- (id) initWithContentsOfURL:(NSURL *)theURL;

/** Returns a package object initialized by reading into it the data from the
 package specified by a given path.

 @param aFilePath path of the package from which to read data
 */
- (id) initWithContentsOfFile:(NSString *)aFilePath;
@end
