/*=====================================================================*/
/*    serrano/prgm/project/hop/hop/hopscript/bglhopscript.h            */
/*    -------------------------------------------------------------    */
/*    Author      :  Manuel Serrano                                    */
/*    Creation    :  Fri Feb 11 09:35:38 2022                          */
/*    Last change :  Thu Feb 24 09:07:57 2022 (serrano)                */
/*    Copyright   :  2022 Manuel Serrano                               */
/*    -------------------------------------------------------------    */
/*    Macros for accelerating C compilation.                           */
/*=====================================================================*/
#ifndef BGLHOPSCRIPT_H 
#define BGLHOPSCRIPT_H

#include <bigloo.h>

/*---------------------------------------------------------------------*/
/*    import                                                           */
/*---------------------------------------------------------------------*/
extern bool_t hop_js_toboolean_no_boolean(obj_t);

/*---------------------------------------------------------------------*/
/*    Type predicates                                                  */
/*---------------------------------------------------------------------*/
#if defined(BGL_AAA_SHIFT)
#  define HOP_AAAVAL 1
#  define HOP_TAG(tag) (tag << BGL_AAA_SHIFT | HOP_AAAVAL)
#  define HOP_OBJECTP(o) POINTERP(o)
#  define HOP_OBJECT_HEADER_SIZE(o) BGL_OBJECT_HEADER_AAASIZE(o)
#  define HOP_OBJECT_HEADER_SIZE_SET(o, s) BGL_OBJECT_HEADER_AAASIZE_SET(o, s, HOP_AAAVAL)
#else
#  define HOP_TAG(tag) tag
#  define HOP_OBJECTP(o) BGL_OBJECTP(o)
#  define HOP_OBJECT_HEADER_SIZE(o) BGL_OBJECT_HEADER_SIZE(o)
#  define HOP_OBJECT_HEADER_SIZE_SET(o, s) BGL_OBJECT_HEADER_SIZE_SET(o, s)
#endif

#define HOP_JSOBJECTP(o, tag) \
   (HOP_OBJECTP(o) && ((HOP_OBJECT_HEADER_SIZE(o) & HOP_TAG(tag)) == HOP_TAG(tag)))
   
#define HOP_JSARRAYP(o, tag) \
   (HOP_OBJECTP(o) && HOP_OBJECT_HEADER_SIZE(o) >= HOP_TAG(tag))

#define HOP_JSSTRINGP(o, tag) \
   (HOP_OBJECTP(o) && ((HOP_OBJECT_HEADER_SIZE(o) & HOP_TAG(tag)) == HOP_TAG(tag)))

#define HOP_JSPROCEDUREP(o, tag) \
   (HOP_OBJECTP(o) && ((HOP_OBJECT_HEADER_SIZE(o) & HOP_TAG(tag)) == HOP_TAG(tag)))

/*---------------------------------------------------------------------*/
/*    Objects & properties predicates                                  */
/*---------------------------------------------------------------------*/
#define HOP_JSOBJECT_MODE_INLINEP(o, tag) \
   ((BGL_OBJECT_HEADER_SIZE(o) & tag) == tag)

#define HOP_JSOBJECT_ELEMENTS_INLINEP(_o) \
   (CVECTOR( ((BgL_jsobjectz00_bglt)COBJECT(_o))->BgL_elementsz00 ) ==	\
    (obj_t)(&(((BgL_jsobjectz00_bglt)COBJECT(_o))->BgL_elementsz00) + 1))

/*---------------------------------------------------------------------*/
/*    HOP_JSOBJECT_INLINE_ELEMENTS ...                                 */
/*---------------------------------------------------------------------*/
#define HOP_JSOBJECT_INLINE_ELEMENTS(_o) \
   BVECTOR((obj_t)(&(((BgL_jsobjectz00_bglt)COBJECT(_o))->BgL_elementsz00) + 1))
#define HOP_JSOBJECT_INLINE_ELEMENTS_LENGTH(_o) \
   VECTOR_LENGTH(HOP_JSOBJECT_INLINE_ELEMENTS(_o))

#define HOP_JSOBJECT_INLINE_ELEMENTS_REF(_o, _i) \
   VECTOR_REF(BVECTOR((obj_t)(&(((BgL_jsobjectz00_bglt)COBJECT(_o))->BgL_elementsz00) + 1)), _i)
#define HOP_JSOBJECT_INLINE_ELEMENTS_SET(_o, _i, _v) \
   VECTOR_SET(BVECTOR((obj_t)(&(((BgL_jsobjectz00_bglt)COBJECT(_o))->BgL_elementsz00) + 1)), _i, _v)

/*---------------------------------------------------------------------*/
/*    HOP_JSARRAY_VECTOR_INLINEP                                       */
/*    -------------------------------------------------------------    */
/*    Used to detect when to reset array inline elements before an     */
/*    expansion. This helps the collector not to retain dead arrays    */
/*    still pointed to by these inlined elements.                      */
/*    -------------------------------------------------------------    */
/*    Used also to implement fast vector shift.                        */
/*---------------------------------------------------------------------*/
#define HOP_JSARRAY_VECTOR_INLINEP( _o ) \
   ((CVECTOR( ((BgL_jsarrayz00_bglt)COBJECT(_o))->BgL_vecz00 ) == \
     (obj_t)(&(((BgL_jsarrayz00_bglt)COBJECT(_o))->BgL_vecz00) + 1)) || \
    (CVECTOR( ((BgL_jsarrayz00_bglt)COBJECT(_o))->BgL_vecz00 ) == \
     (CVECTOR(*((obj_t *)(&(((BgL_jsarrayz00_bglt)COBJECT(_o))->BgL_vecz00) + 1))))))
   
/*---------------------------------------------------------------------*/
/*    Conversions                                                      */
/*---------------------------------------------------------------------*/
#define HOP_JSTOTEST(o) \
   (BOOLEANP(o)		\
    ? CBOOL(o)          \
    : (BGL_NULL_OR_UNSPECIFIEDP(o) ? 0 : hop_js_toboolean_no_boolean(o)))

/*---------------------------------------------------------------------*/
/*    Arithmetic ops                                                   */
/*---------------------------------------------------------------------*/
#define HOP_JSEQIL(x, y) \
   (BINT(x) == y || (REALP(y) && (((double) x) == REAL_TO_DOUBLE(y))))
#endif