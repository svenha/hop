;*=====================================================================*/
;*    serrano/prgm/project/hop/3.2.x/hopscript/arithmetic32.scm        */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Mon Dec  4 19:36:39 2017                          */
;*    Last change :  Mon Dec 11 08:14:25 2017 (serrano)                */
;*    Copyright   :  2017 Manuel Serrano                               */
;*    -------------------------------------------------------------    */
;*    Arithmetic operations on 32 bit platforms                        */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module __hopscript_arithmetic32

   (library hop)

   (include "types.sch" "stringliteral.sch")

   (import __hopscript_types
	   __hopscript_object
	   __hopscript_function
	   __hopscript_string
	   __hopscript_error
	   __hopscript_property
	   __hopscript_private
	   __hopscript_public)

   (cond-expand
      ((or bint30 bint32)
       (export
	  (inline overflow29 ::long)

	  (js-number-toint32::int32 ::obj)
	  (js-number-touint32::uint32 ::obj)
	  
	  (inline js-int32-tointeger::obj ::int32)
	  (inline js-uint32-tointeger::obj ::uint32)
	  
	  (inline +fx/overflow::obj ::long ::long)
	  (inline +s32/overflow::obj ::int32 ::int32)
	  (inline +u32/overflow::obj ::uint32 ::uint32)
	  (+/overflow::obj ::obj ::obj)
	  
	  (inline -fx/overflow::obj ::long ::long)
	  (inline -s32/overflow::obj ::int32 ::int32)
	  (inline -u32/overflow::obj ::uint32 ::uint32)
	  (-/overflow::obj ::obj ::obj)
	  
	  (inline *fx/overflow::obj ::long ::long)
	  (inline *u32/overflow::obj ::uint32 ::uint32)
	  (*/overflow::obj ::obj ::obj)
	  ))))

;*---------------------------------------------------------------------*/
;*    js-number-toint32 ::obj ...                                      */
;*    -------------------------------------------------------------    */
;*    http://www.ecma-international.org/ecma-262/5.1/#sec-9.5          */
;*---------------------------------------------------------------------*/
(define (js-number-toint32::int32 obj)
   
   (define (int64->int32::int32 obj::int64)
      (let* ((i::llong (int64->llong obj))
	     (^31 (*llong #l8 (fixnum->llong (bit-lsh 1 28))))
	     (^32 (*llong #l2 ^31))
	     (posint (if (<llong i #l0) (+llong ^32 i) i))
	     (int32bit (modulollong posint ^32))
	     (n (if (>=llong int32bit ^31)
		    (-llong int32bit ^32)
		    int32bit)))
	 (llong->int32 n)))
   
   (cond
      ((fixnum? obj)
       (fixnum->int32 obj))
      ((flonum? obj)
       (cond
	  ((or (= obj +inf.0) (= obj -inf.0) (nanfl? obj))
	   (fixnum->int32 0))
	  ((<fl obj 0.)
	   (let ((i (*fl -1. (floor (abs obj)))))
	      (if (>=fl i (negfl (exptfl 2. 31.)))
		  (fixnum->int32 (flonum->fixnum i))
		  (int64->int32 (flonum->int64 i)))))
	  (else
	   (let ((i (floor obj)))
	      (if (<=fl i (-fl (exptfl 2. 31.) 1.))
		  (fixnum->int32 (flonum->fixnum i))
		  (int64->int32 (flonum->int64 i)))))))
      ((uint32? obj)
       (uint32->int32 obj))
      ((int32? obj)
       obj)
      (else
       (error "js-number-toint32" "bad number type" obj))))

;*---------------------------------------------------------------------*/
;*    js-number-touint32 ...                                           */
;*---------------------------------------------------------------------*/
(define (js-number-touint32::uint32 obj)
   
   (define 2^32 (exptfl 2. 32.))
   
   (define (positive-double->uint32::uint32 obj::double)
      (if (<fl obj 2^32)
	  (flonum->uint32 obj)
	  (flonum->uint32 (remainderfl obj 2^32))))
   
   (define (double->uint32::uint32 obj::double)
      (cond
	 ((or (= obj +inf.0) (= obj -inf.0) (not (= obj obj)))
	  #u32:0)
	 ((<fl obj 0.)
	  (positive-double->uint32 (+fl 2^32 (*fl -1. (floor (abs obj))))))
	 (else
	  (positive-double->uint32 obj))))
   
   (cond
      ((fixnum? obj)
       (cond-expand
	  (bint30 (fixnum->uint32 obj))
	  (else (int32->uint32 (fixnum->int32 obj)))))
      ((flonum? obj)
       (double->uint32 obj))
      ((int32? obj)
       (int32->uint32 obj))
      ((uint32? obj)
       obj)
      (else
       (error "js-number-touint32" "bad number type" obj))))

;*---------------------------------------------------------------------*/
;*    overflow29 ...                                                   */
;*    -------------------------------------------------------------    */
;*    2^53-1 overflow                                                  */
;*    -------------------------------------------------------------    */
;*    See Hacker's Delight (second edition), H. Warren J.r,            */
;*    Chapter 4, section 4.1, page 68                                  */
;*---------------------------------------------------------------------*/
(define-inline (overflow29 v::long)
   (let* ((a (-fx 0 (bit-lsh 1 29)))
	  (b (-fx (bit-lsh 1 29) 1))
	  (b-a (-fx b a)))
      (if (<=u32 (fixnum->uint32 (-fx v a)) (fixnum->uint32 b-a))
	  v
	  (fixnum->flonum v))))

;*---------------------------------------------------------------------*/
;*    js-int32-tointeger ...                                           */
;*---------------------------------------------------------------------*/
(define-inline (js-int32-tointeger::obj i::int32)
   (cond-expand
      (bint30
       (if (and (<s32 i (bit-lshs32 #s32:1 29))
		(>=s32 i (negs32 (bit-lshs32 #s32:1 29))))
	   (int32->fixnum i)
	   (int32->flonum i)))
      (bint32
       (if (and (<s32 i (-s32 (bit-lshs32 #s32:1 31) #s32:1))
		(>=s32 i (negs32 (bit-lshs32 #s32:1 31))))
	   (int32->fixnum i)
	   (int32->flonum i)))))

;*---------------------------------------------------------------------*/
;*    js-uint32-tointeger ...                                          */
;*---------------------------------------------------------------------*/
(define-inline (js-uint32-tointeger::obj i::uint32)
   (cond-expand
      (bint30
       (if (<u32 i (-u32 (bit-lshu32 #u32:1 30) #u32:1))
	   (uint32->fixnum i)
	   (uint32->flonum i)))
      (bint32
       (if (<u32 i (-u32 (bit-lshu32 #u32:1 31) #u32:1))
	   (uint32->fixnum i)
	   (uint32->flonum i)))))

;*---------------------------------------------------------------------*/
;*    tolong ...                                                       */
;*---------------------------------------------------------------------*/
(define (tolong x)
   (cond
      ((fixnum? x) x)
      ((int32? x) (int32->fixnum x))
      ((and (uint32? x) (<u32 x (-u32 (bit-lshu32 #u32:1 30) #u32:1)))
       (uint32->fixnum x))
      (else #f)))

;*---------------------------------------------------------------------*/
;*    todouble ...                                                     */
;*---------------------------------------------------------------------*/
(define (todouble::double x)
   (cond
      ((fixnum? x) (fixnum->flonum x))
      ((int32? x) (int32->flonum x))
      ((uint32? x) (uint32->flonum x))
      (else x)))

;*---------------------------------------------------------------------*/
;*    +fx/overflow ...                                                 */
;*    -------------------------------------------------------------    */
;*    The argument are 30bit integers encoded into long values.        */
;*---------------------------------------------------------------------*/
(define-inline (+fx/overflow x::long y::long)
   (overflow29 (+fx x y)))

;*---------------------------------------------------------------------*/
;*    +fx32/overflow ...                                               */
;*    -------------------------------------------------------------    */
;*    X and Y are true 32bit values.                                   */
;*---------------------------------------------------------------------*/
(define (+fx32/overflow x::long y::long)
   (cond-expand
      ((and bigloo-c (config have-overflow #t))
       (let ((res::long 0))
	  (if (pragma::bool "__builtin_saddl_overflow($1, $2, &$3)"
		 x y (pragma res))
	      (pragma::real "DOUBLE_TO_REAL(((double)($1))+((double)($2)))"
		 x y)
	      (overflow29 res))))
      (else
       (let ((z::long (pragma::long "(~($1 ^ $2)) & 0x80000000" x y)))
	  (if (pragma::bool "$1 & (~((($2 ^ $1) + ($3)) ^ ($3)))" z x y)
	      (fixnum->flonum (+fx x y))
	      (overflow29 (+fx x y)))))))

;*---------------------------------------------------------------------*/
;*    +s32/overflow ...                                                */
;*---------------------------------------------------------------------*/
(define-inline (+s32/overflow x::int32 y::int32)
   (+fx32/overflow (int32->fixnum x) (int32->fixnum y)))

;*---------------------------------------------------------------------*/
;*    +u32/overflow ...                                                */
;*---------------------------------------------------------------------*/
(define-inline (+u32/overflow x::uint32 y::uint32)
   (cond-expand
      ((and bigloo-c (config have-overflow #t))
       (let ((res::long 0))
	  (if (pragma::bool "__builtin_uaddl_overflow($1, $2, &$3)"
		 x y (pragma res))
	      (pragma::real "DOUBLE_TO_REAL(((double)($1))+((double)($2)))"
		 x y)
	      (overflow29 res))))
      (else
       (let ((z::long (pragma::long "(~($1 ^ $2)) & 0x80000000" x y)))
	  (if (pragma::bool "$1 & (~((($2 ^ $1) + ($3)) ^ ($3)))" z x y)
	      (fixnum->flonum (+fx x y))
	      (overflow29 (+fx x y)))))))

;*---------------------------------------------------------------------*/
;*    +/overflow ...                                                   */
;*    -------------------------------------------------------------    */
;*    This function is the compiler fallback used when it finds no     */
;*    specialized addition function. In practice it should hardly      */
;*    be called.                                                       */
;*---------------------------------------------------------------------*/
(define (+/overflow x::obj y::obj)
   (let ((ll (tolong x)))
      (if ll
	  (let ((rl (tolong y)))
	     (if rl
		 (+fx32/overflow ll rl)
		 (+fl (todouble x) (todouble y))))
	  (+fl (todouble x) (todouble y)))))

;*---------------------------------------------------------------------*/
;*    -fx/overflow ...                                                 */
;*    -------------------------------------------------------------    */
;*    The argument are 30bit integers encoded into long values.        */
;*---------------------------------------------------------------------*/
(define-inline (-fx/overflow x::long y::long)
   (overflow29 (-fx x y)))

;*---------------------------------------------------------------------*/
;*    -fx32/overflow ...                                               */
;*    -------------------------------------------------------------    */
;*    X and Y are true 32bit values.                                   */
;*---------------------------------------------------------------------*/
(define (-fx32/overflow x::long y::long)
   (cond-expand
      ((and bigloo-c (config have-overflow #t))
       (let ((res::long 0))
	  (if (pragma::bool "__builtin_ssubl_overflow($1, $2, &$3)"
		 x y (pragma res))
	      (pragma::real "DOUBLE_TO_REAL(((double)($1))-((double)($2)))"
		 x y)
	      res)))
      (else
       (let ((z::long (pragma::long "($1 ^ $2) & 0x80000000" x y)))
	  (if (pragma::bool "$1 & ((($2 ^ (long)$1) - ($3)) ^ ($3))" z x y)
	      (fixnum->flonum (-fx x y))
	      (-fx x y))))))
   
;*---------------------------------------------------------------------*/
;*    -s32/overflow ...                                                */
;*---------------------------------------------------------------------*/
(define-inline (-s32/overflow x::int32 y::int32)
   (-fx32/overflow (int32->fixnum x) (int32->fixnum y)))

;*---------------------------------------------------------------------*/
;*    -u32/overflow ...                                                */
;*---------------------------------------------------------------------*/
(define-inline (-u32/overflow x::uint32 y::uint32)
   (cond-expand
      ((and bigloo-c (config have-overflow #t))
       (let ((res::long 0))
	  (if (pragma::bool "__builtin_usubl_overflow($1, $2, &$3)"
		 x y (pragma res))
	      (pragma::real "DOUBLE_TO_REAL(((double)($1))+((double)($2)))"
		 x y)
	      (overflow29 res))))
      (else
       (let ((z::long (pragma::long "(~($1 ^ $2)) & 0x80000000" x y)))
	  (if (pragma::bool "$1 & ((($2 ^ (long)$1) - ($3)) ^ ($3))" z x y)
	      (fixnum->flonum (+fx x y))
	      (overflow29 (+fx x y)))))))

;*---------------------------------------------------------------------*/
;*    -/overflow ...                                                   */
;*    -------------------------------------------------------------    */
;*    This function is the compiler fallback used when it finds no     */
;*    specialized addition function. In practice it should hardly      */
;*    be called.                                                       */
;*---------------------------------------------------------------------*/
(define (-/overflow x::obj y::obj)
   (let ((ll (tolong x)))
      (if ll
	  (let ((rl (tolong y)))
	     (if rl
		 (-fx32/overflow ll rl)
		 (-fl (todouble x) (todouble y))))
	  (-fl (todouble x) (todouble y)))))

;*---------------------------------------------------------------------*/
;*    *fx/overflow ...                                                 */
;*    -------------------------------------------------------------    */
;*    The argument are 30bit integers encoded into long values.        */
;*---------------------------------------------------------------------*/
(define-inline (*fx/overflow x::long y::long)
   (cond-expand
      ((and bigloo-c (config have-overflow #t))
       (let ((res::long 0))
	  (if (pragma::bool "__builtin_smull_overflow($1, $2, &$3)"
		 x y (pragma res))
	      (pragma::real "DOUBLE_TO_REAL(((double)($1))-((double)($2)))"
		 x y)
	      (overflow29 res))))
      (else
       (let ((z::long (pragma::long "($1 ^ $2) & 0x80000000" x y)))
	  (if (pragma::bool "$1 & ((($2 ^ (long)$1) - ($3)) ^ ($3))" z x y)
	      (fixnum->flonum (*fx x y))
	      (overflow29 (*fx x y)))))))

;*---------------------------------------------------------------------*/
;*    *u32/overflow ...                                                */
;*    -------------------------------------------------------------    */
;*    The argument are 30bit integers encoded into long values.        */
;*---------------------------------------------------------------------*/
(define-inline (*u32/overflow x::uint32 y::uint32)
   (cond-expand
      ((and bigloo-c (config have-overflow #t))
       (let ((res::long 0))
	  (if (pragma::bool "__builtin_umull_overflow($1, $2, &$3)"
		 x y (pragma res))
	      (pragma::real "DOUBLE_TO_REAL(((double)($1))-((double)($2)))"
		 x y)
	      (if (<u32 res (bit-lshu32 #u32:1 29))
		  (uint32->fixnum res)
		  (uint32->flonum res)))))
      (else
       (let ((z::long (pragma::uint32 "($1 ^ $2) & 0x80000000" x y)))
	  (if (pragma::bool "$1 & ((($2 ^ (uint32)$1) - ($3)) ^ ($3))" z x y)
	      (fixnum->flonum (*u32 x y))
	      (let ((res (*u32 x y)))
		 (if (<u32 res (bit-lshu32 #u32:1 29))
		     (uint32->fixnum res)
		     (uint32->flonum res))))))))

;*---------------------------------------------------------------------*/
;*    */overflow ...                                                   */
;*---------------------------------------------------------------------*/
(define (*/overflow x y)
   (let ((ll (tolong x)))
      (if ll
	  (let ((rl (tolong y)))
	     (if rl
		 (*fx/overflow ll rl)
		 (*fl (todouble x) (todouble y))))
	  (*fl (todouble x) (todouble y)))))