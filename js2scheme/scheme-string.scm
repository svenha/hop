;*=====================================================================*/
;*    serrano/prgm/project/hop/3.2.x/js2scheme/scheme-string.scm       */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Thu Oct  5 05:47:06 2017                          */
;*    Last change :  Fri Oct  6 20:05:34 2017 (serrano)                */
;*    Copyright   :  2017 Manuel Serrano                               */
;*    -------------------------------------------------------------    */
;*    Scheme code generation of JavaScript string functions.           */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The module                                                       */
;*---------------------------------------------------------------------*/
(module __js2scheme_scheme-string

   (include "ast.sch")
   
   (import __js2scheme_ast
	   __js2scheme_dump
	   __js2scheme_utils
	   __js2scheme_js
	   __js2scheme_stmtassign
	   __js2scheme_compile
	   __js2scheme_stage
	   __js2scheme_scheme
	   __js2scheme_scheme-utils
	   __js2scheme_scheme-fun)

   (export (j2s-jsstring-replace-regexp obj args mode return conf hint totype)
	   (j2s-jsstring-replace obj args mode return conf hint totype)))

;*---------------------------------------------------------------------*/
;*    j2s-string-replace-regexp ...                                    */
;*---------------------------------------------------------------------*/
(define (j2s-jsstring-replace-regexp obj args mode return conf hint totype)
   
   (define (literal-regexp obj)
      (when (isa? obj J2SLiteralCnst)
	 (with-access::J2SLiteralCnst obj (val index)
	    (when (isa? val J2SRegExp)
	       index))))
   
   (define (mark-inline! obj)
      (with-access::J2SLiteralCnst obj (val)
	 (with-access::J2SRegExp val (inline)
	    (set! inline #t))))
   
   (define (tmp obj kont)
      (if (isa? obj J2SRef)
	  (kont (j2s-scheme obj mode return conf hint totype))
	  (let ((tmp (gensym 'obj)))
	     `(let ((,tmp ,(j2s-scheme obj mode return conf hint totype)))
		 ,(kont tmp)))))
   
   (define (fun1? obj)
      (when (isa? obj J2SFun)
	 (with-access::J2SFun obj (vararg params)
	    (unless vararg
	       (=fx (length params) 1)))))
   
   (define (replace tmp rx index global)
      (let ((replacevalue (cadr args)))
	 (cond
	    ((fun1? replacevalue)
	     `(js-jsstring-replace-regexp-fun1 ,tmp
		 ,rx 0 ,global
		 ,(jsfun->lambda replacevalue mode return conf #f #f)
		 ,@(map (lambda (arg)
			   (j2s-scheme arg
			      mode return conf hint totype))
		      (cddr args))))
	    (else
	     `(js-jsstring-replace-regexp ,tmp
		 ,rx 0 ,global
		 ,(j2s-scheme replacevalue
		     mode return conf hint totype)
		 ,@(map (lambda (arg)
			   (j2s-scheme arg
			      mode return conf hint totype))
		      (cddr args)))))))

   (if (literal-regexp (car args))
       (with-access::J2SLiteralCnst (car args) (val index)
	  (with-access::J2SRegExp val (inline flags)
	     (set! inline #t)
	     (let ((global (when (string? flags)
			      (integer? (string-index flags #\g)))))
		(tmp obj
		   (lambda (tmp)
		      (replace tmp `(vector-ref-ur %cnsts ,index) 0 global))))))
       (let ((regexp (j2s-scheme (car args) mode return conf hint totype)))
	  (tmp obj
	     (lambda (tmp)
		`(with-access::JsRegExp ,regexp (rx lastindex global)
		    (with-access::JsValueDescriptor lastindex ((lastindex value))
		       (with-access::JsValueDescriptor global ((global value))
			  ,(replace tmp 'rx 'lastindex 'global)))))))))
	   
;*---------------------------------------------------------------------*/
;*    j2s-string-replace ...                                           */
;*---------------------------------------------------------------------*/
(define (j2s-jsstring-replace obj args mode return conf hint totype)
   `(js-jsstring-replace
       ,(j2s-scheme obj mode return conf hint totype)
       ,@(map (lambda (arg)
		 (j2s-scheme arg mode return conf hint totype))
	    args)))
	   
