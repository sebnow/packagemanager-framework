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
#import "PMPackage.h"
#import <alpm.h>

@interface PMPackage (Private)
/* Initialize a PMPackage object using a liblapm package reference. This should
 only be used for initializing PMPackage wrapper objects from existing libalpm
 pmpkg_t structures (i.e., low-level operations). */
- (id) _initUsingALPMPackage:(pmpkg_t *)aPackage;

/* Initialize a PMPackage object using a libalpm package reference and an
 existing PMDatabase object. This is so that PMDatabase objects are not
 duplicated (two objects having the same pmpkg_t reference). */
- (id) _initUsingALPMPackage:(pmpkg_t *)aPackage database:(PMDatabase *)aDatabase;
@end
