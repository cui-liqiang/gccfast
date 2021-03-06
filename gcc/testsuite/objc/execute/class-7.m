/* Contributed by Nicola Pero - Tue Mar  6 23:05:53 CET 2001 */
#include <objc/objc.h>
#include <objc/objc-api.h>

/* APPLE LOCAL objc test suite */      
#include "next_mapping.h"

/* Tests creating a root class and a subclass with an ivar and
   accessor methods; accessor methods implemented in a separate
   category */

@interface RootClass
{
  Class isa;
}
@end

@implementation RootClass
/* APPLE LOCAL begin objc test suite */
#ifdef __NEXT_RUNTIME__                                   
+ initialize { return self; }
#endif
/* APPLE LOCAL end objc test suite */
@end

@interface SubClass : RootClass
{
  int state;
}
@end

@implementation SubClass
@end

@interface SubClass (Additions)
- (void) setState: (int)number;
- (int) state;
@end

@implementation SubClass (Additions)
- (void) setState: (int)number
{
  state = number;
}
- (int) state
{
  return state;
}
@end

#include "class-tests-1.h"
#define TYPE_OF_OBJECT_WITH_ACCESSOR_METHOD SubClass *
#include "class-tests-2.h"

int main (void)
{
  SubClass *object;

  test_class_with_superclass ("SubClass", "RootClass");

  /* APPLE LOCAL begin objc test suite */
#ifdef __NEXT_RUNTIME__
  /* The NeXT runtime's category implementation is lazy: categories are not attached 
     to classes until the class is initialized (at +initialize time).  */
  [SubClass initialize];
#endif
  /* APPLE LOCAL end objc test suite */

  test_that_class_has_instance_method ("SubClass", @selector (setState:));
  test_that_class_has_instance_method ("SubClass", @selector (state));

  object = class_create_instance (objc_lookup_class ("SubClass"));
  test_accessor_method (object, 0, 1, 1, -3, -3);

  return 0;
}
