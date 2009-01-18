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
#import "PMDatabase.h"
#import <alpm.h>

@interface PMDatabase (Private)
/* Initialize a PMDatabase object using a libalpm database reference.
 This is only meant for subclasses, as a way of setting the _database instance
 variable and associated properties, and in fact should not be used at all,
 however this seems like the best solution. */
- (id) _initUsingALPMDatabase:(pmdb_t *)aDatabase;

/* Returns a reference to the underlying libalpm database. This is only to be
 used by other low-level classes in the framework. Normally the @package scope
 modifier would be used, but it is not supported by standard GCC, so we have to
 settle for a private method. */
- (pmdb_t *) _database;
@end
