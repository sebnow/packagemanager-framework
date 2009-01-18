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

/** A database containing packages.
 Each database has a name and an array of packages. Since this is an abstract
 class, the management of packages is up to subclasses. For convenience the
 #packages and #filteredPackagesUsingPredicate: messages are provided for
 retrieving an array of packages, as this is common behavior.

 @remarks This is an abstract class
 @author Sebastian Nowicki <sebnow@gmail.com>
 */
@interface PMDatabase : NSObject {
	/** Reference to the underlying libalpm database. */
	struct __pmdb_t *_database;
	/** Name of the database */
	NSString *_name;
}

/** Return the name of the database
 @return name of database
 */
- (NSString *) name;

/** Filter packages in database matching \a thePredicate.
 Evaluates a given predicate against each package in the receiver and returns a
 new array containing the package for which the predicate returns true.

 @param thePredicate predicate against which to evaluate the receiver’s packages
 @return a new array containing the packages in the receiver for which
 \a thePredicate returns true
 */
- (NSArray *) filteredPackagesUsingPredicate:(NSPredicate *)thePredicate;

/** Retrieve an array of PMPackage objects.
 @return array of PMPackage objects
 */
- (NSArray *) packages;

/** Retrieve a single PMPackage matching the specified name.
 @param aName name of the package to be retrieved
 @return a PMPackage with the specified name
 */
- (PMPackage *) packageWithName:(NSString *)aName;

@end
