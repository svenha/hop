;*=====================================================================*/
;*    serrano/prgm/project/hop/3.2.x/etc/hopjs.el                      */
;*    -------------------------------------------------------------    */
;*    Author      :  Manuel Serrano                                    */
;*    Creation    :  Sun May 25 13:05:16 2014                          */
;*    Last change :  Fri Nov 16 12:28:35 2018 (serrano)                */
;*    Copyright   :  2014-18 Manuel Serrano                            */
;*    -------------------------------------------------------------    */
;*    HOPJS customization of the standard js-mode                      */
;*=====================================================================*/

;*---------------------------------------------------------------------*/
;*    The package                                                      */
;*---------------------------------------------------------------------*/
(provide 'hopjs)
(require 'json)
(require 'js)

(require 'hopjs-config)
(require 'hopjs-parse)
(require 'hopjs-indent)

(define-key (current-local-map)
  "\C-x\C-z"
  '(lambda ()
     (interactive)
     (load-library "hopjs.el")
     (load-library "hopjs-macro.el")
     (load-library "hopjs-parse.el")
     (load-library "hopjs-indent.el")
     (load-library "hopjs-config.el")))

(define-key (current-local-map)
  "\C-x\C-a"
  '(lambda (pos)
     (interactive "d")
     (with-debug "-------------- hopjs-indent" (hopjs-indent pos))))

(define-key (current-local-map)
  "\C-x\C-e"
  '(lambda ()
     (interactive)
     (let ((pos (point)))
       (message "------------- hopjs-parse-line %s -> %s"
		pos (hopjs-parse-line pos)))))

(define-key (current-local-map)
  "\C-x\C-e"
  '(lambda ()
     (interactive)
     (let ((pos (point)))
       (message "------------- hopjs-parse-line %s -> %s"
		pos (hopjs-parse-line pos)))))

(define-key (current-local-map)
  "\C-x\C-e"
  '(lambda ()
     (interactive)
     (let ((pos (point)))
       (message "------------- hopjs-parse-line %s -> %s"
		pos (hopjs-parse-line pos)))))

(define-key (current-local-map)
  "\C-x\C-t"
  'hopjs-indent-test)

;*---------------------------------------------------------------------*/
;*    font-lock ...                                                    */
;*---------------------------------------------------------------------*/
(defconst hopjs-font-lock-keywords
  (list (list "\\s-*\\(service\\)\\(?:\\s-+\\|(\\)" 1 'font-lock-keyword-face)
	(list ".\\(\\(?:post\\|then\\|catch\\)\\(?:Sync\\|Message\\)?\\)\\(?:\\s-+\\|(\\)" 1 'font-lock-face-hopjs2)
	(cons "</?[a-zA-Z0-9_.-]+[ ]*>\\|[ ]*/>\\|<[^ /]*/>" 'font-lock-face-hopjs9)
	(list "\\(</?[a-zA-Z0-9_.:-]+\\)[ ]+[a-zA-Z0-9_]" 1 'font-lock-face-hopjs9)
	(cons "<!--\\([^-]\\|-[^-]\\|--[^>]\\)+-[-]+>" 'font-lock-comment-face)
	(list "[}\"][ ]*\\(>\\)" 1 'font-lock-face-hopjs9)
	(cons "$\{[^ \t\r\n{}]*\}" 'font-lock-face-hopjs2)
	(list "\\([$]\\){" 1 'font-lock-face-hopjs2)
	(list "\\([~]\\){" 1 'font-lock-face-hopjs3)
	(cons "[0-9a-zA-Z_-]+:" 'font-lock-face-hopjs10)
	(cons "https?://[^ \t]*" 'font-lock-string-face)
	(cons "\\<\\(?:async\\|yield\\|await\\)\\>" 'font-lock-face-hopjs3)
	(list "#:\\([^ \t\r\n{}(),;=[]*\\)" 1 'font-lock-face-hopjs3)
	(cons "exports." 'font-lock-keyword-face)
	(list "\\(require\\)([ \t]*\\(\"[^\"]+\"\\)"
	      '(1 font-lock-keyword-face)
	      '(2 font-lock-face-underline))
	(list (concat "^\\s-*\\(?:service\\)\\s-+\\(" js--name-re "\\)") 1 'font-lock-function-name-face)))

;*---------------------------------------------------------------------*/
;*    hopjs-make-face ...                                              */
;*---------------------------------------------------------------------*/
(defun hopjs-make-face (l)
  (let ((fname (car l))
	(color (car (cdr l)))
	(bgcolor (car (cdr (cdr l))))
	(italic (car (cdr (cdr (cdr l)))))
	(bold (car (cdr (cdr (cdr (cdr l))))))
	(underline (car (cdr (cdr (cdr (cdr l)))))))
    (let ((face (copy-face 'default fname)))
      (when color
	(set-face-foreground face color))
      (when bgcolor
	(set-face-background face bgcolor))
      (when italic
	(make-face-italic face))
      (when bold
	(make-face-bold face))
      (when underline
	(set-face-underline face nil))
      face)))

(defvar font-lock-face-hopjs0
  (hopjs-make-face (list 'font-lock-face-hopjs0 "gray50" nil nil t nil)))
(defvar font-lock-face-hopjs1
  (hopjs-make-face (list 'font-lock-face-hopjs1 "slateblue3" nil nil t nil)))
(defvar font-lock-face-hopjs2
  (hopjs-make-face (list 'font-lock-face-hopjs2 "blue" nil nil t nil)))
(defvar font-lock-face-hopjs3
  (hopjs-make-face (list 'font-lock-face-hopjs3 "tomato2" nil nil t nil)))
(defvar font-lock-face-hopjs4
  (hopjs-make-face (list 'font-lock-face-hopjs4 "green3" nil nil t nil)))
(defvar font-lock-face-hopjs5
  (hopjs-make-face (list 'font-lock-face-hopjs5 "red" nil nil t nil)))
(defvar font-lock-face-hopjs6
  (hopjs-make-face (list 'font-lock-face-hopjs6 "BlueViolet" nil nil t nil)))
(defvar font-lock-face-hopjs7
  (hopjs-make-face (list 'font-lock-face-hopjs7 "green3" nil nil t nil)))
(defvar font-lock-face-hopjs8
  (hopjs-make-face (list 'font-lock-face-hopjs8 "Goldenrod" nil nil t nil)))
(defvar font-lock-face-hopjs9
  (hopjs-make-face (list 'font-lock-face-hopjs9 "#87910F" nil nil t nil)))
(defvar font-lock-face-hopjs10
  (hopjs-make-face (list 'font-lock-face-hopjs10 "lightslateblue" nil nil nil)))
(defvar font-lock-face-hopjs11
  (hopjs-make-face (list 'font-lock-face-hopjs11 "Orchid" nil nil t nil)))
(defvar font-lock-face-hopjs12
  (hopjs-make-face (list 'font-lock-face-hopjs12 "white" "gray50" nil t nil)))
(defvar font-lock-face-hopjs13
  (hopjs-make-face (list 'font-lock-face-hopjs13 "white" "tomato2" nil t nil)))
(defvar font-lock-face-underline
  (hopjs-make-face (list 'font-lock-face-underline nil nil nil nil t)))

;*---------------------------------------------------------------------*/
;*    Highlighting                                                     */
;*---------------------------------------------------------------------*/
(defface hopjs-nomatch-face
  '((((class color)) (:background "Red"))
    (t (:weight bold)))
  "Face used for marking a nomatched tag."
  :group 'hopjs)

(defface hopjs-match-face
  '((((class color)) (:background "Green"))
    (t (:weight bold)))
  "Face used for marking a matched tag."
  :group 'hopjs)

(defface hopjs-doc-face
  '((((class color)) (:background "Yellow" :underline t))
    (t (:underline t)))
  "Face used for marking a document entry."
  :group 'hopjs)

(defvar hopjs-tag-overlays nil)

;*---------------------------------------------------------------------*/
;*    put-text-properties ...                                          */
;*---------------------------------------------------------------------*/
(defun put-text-properties (start end &rest props)
  (let ((ov (make-overlay start end nil t nil))
	(mod (buffer-modified-p)))
    (while (consp props)
      (overlay-put ov (car props) (cadr props))
      (setq props (cddr props)))
    (set-buffer-modified-p mod)))

;*---------------------------------------------------------------------*/
;*    remove-text-property ...                                         */
;*---------------------------------------------------------------------*/
(defun remove-text-property (start end prop &optional object)
  (let ((l (overlays-in start end)))
    (while (consp l)
      (let ((o (car l)))
	(setq l (cdr l))
	(if (overlayp o)
	    (if (overlay-get o prop)
		(delete-overlay o)))))))

;*---------------------------------------------------------------------*/
;*    buffer-match ...                                                 */
;*---------------------------------------------------------------------*/
(defun buffer-match (idx)
  (buffer-substring-no-properties (match-beginning idx) (match-end idx)))

;*---------------------------------------------------------------------*/
;*    nullp ...                                                        */
;*---------------------------------------------------------------------*/
(defun nullp (o)
  (eq o '()))

;*---------------------------------------------------------------------*/
;*    hopjs-syntax ...                                                 */
;*---------------------------------------------------------------------*/
(defun hopjs-syntax ()
  "Syntax table for `hopjs-mode'."
  (let ((table (syntax-table)))
    (modify-syntax-entry ?\` "\"    " table)
    table))

;*---------------------------------------------------------------------*/
;*    hopjs-re-open-tag ...                                            */
;*---------------------------------------------------------------------*/
(defconst hopjs-re-open-tag
  "<\\([a-zA-Z_$][a-zA-Z0-9_.:$!-]*\\)\\(?:[ \t\n]*>\\|[ \t\n]+[a-zA-Z0-9_-]\\)")
(defconst hopjs-re-close-tag
  "</\\([a-zA-Z_$][a-zA-Z0-9_.:$!-]*\\)[ \t]*>")
(defconst hopjs-re-end-tag
  "/>")
(defconst hopjs-re-standalone-tag
  "<\\([^>/\n]\\|/[^>]\\)*/>")

(defconst hopjs-re-special-tag
  "<\\(link\\|LINK\\)")

(defconst hopjs-re-any-tag
  (concat hopjs-re-open-tag
	  "\\|" hopjs-re-close-tag
	  "\\|" hopjs-re-end-tag
	  "\\|" hopjs-re-standalone-tag))

;*---------------------------------------------------------------------*/
;*    debugging                                                        */
;*---------------------------------------------------------------------*/
(defun hopjs-no-debug (shift fmt &rest l)
  '())

(defun hopjs-debug (shift fmt &rest l)
  (when (> shift 0)
    (setq hopjs-debug-level (+ hopjs-debug-level shift)))
  (when hopjs-debug
    (apply 'message
	   (hopjs-debug-format
	    fmt (cond ((> shift 0) "> ") ((< shift 0) "< ") (t "- ")))
	   l))
  (when (< shift 0)
    (setq hopjs-debug-level (+ hopjs-debug-level shift))))

(defun hopjs-debug-format (fmt mark )
  (cl-case hopjs-debug-level
    ((0) fmt)
    ((1) (concat mark fmt))
    ((2) (concat " " mark fmt))
    ((3) (concat "  " mark fmt))
    ((4) (concat "   " mark fmt))
    ((5) (concat "    " mark fmt))
    ((6) (concat "     " mark fmt))
    ((7) (concat "      " mark fmt))
    ((8) (concat "       " mark fmt))
    ((9) (concat "        " mark fmt))
    ((10) (concat "         " mark fmt))
    ((11) (concat "          " mark fmt))
    ((12) (concat "           " mark fmt))
    ((13) (concat "            " mark fmt))
    ((14) (concat "             " mark fmt))
    ((15) (concat "              " mark fmt))
    ((16) (concat "               " mark fmt))
    (t (concat "         ~" mark fmt))))
   
(defconst hopjs-debug (or t (getenv "EMACSDEBUG")))

(defvar hopjs-debug-level 0)
(setq hopjs-debug-level 0)

;*---------------------------------------------------------------------*/
;*    call-sans-debug ...                                              */
;*---------------------------------------------------------------------*/
(defun call-sans-debug (f &rest l)
  (let ((dbg hopjs-debug))
    (setq hopjs-debug nil)
    (let ((tmp (apply f l)))
      (setq hopjs-debug dbg)
      tmp)))

;*---------------------------------------------------------------------*/
;*    hopjs-electric-brace ...                                         */
;*---------------------------------------------------------------------*/
(defun hopjs-electric-brace ()
  "Insert and indent line."
  (interactive)
  (insert "}")
  (indent-for-tab-command))

;*---------------------------------------------------------------------*/
;*    hopjs-electric-paren ...                                         */
;*---------------------------------------------------------------------*/
(defun hopjs-electric-paren ()
  "Insert and indent line."
  (interactive)
  (insert ")")
  (indent-for-tab-command))

;*---------------------------------------------------------------------*/
;*    hopjs-electric-abra ...                                          */
;*---------------------------------------------------------------------*/
(defun hopjs-electric-abra ()
  "Insert and indent line."
  (interactive)
  (insert ">")
  (indent-for-tab-command))

;*---------------------------------------------------------------------*/
;*    hopjs-pos-eolp ...                                               */
;*---------------------------------------------------------------------*/
(defun hopjs-pos-eolp (pos)
  (save-excursion
    (goto-char pos)
;*     (looking-at "\\([^<>]*>\\)?[ \t]*$")                            */
    (looking-at "[ \t]*$")))

;*---------------------------------------------------------------------*/
;*    hopjs-pos-bolp ...                                               */
;*---------------------------------------------------------------------*/
(defun hopjs-pos-bolp (pos)
  (save-excursion
    (goto-char pos)
    (back-to-indentation)
    (= (point) pos)))

;*---------------------------------------------------------------------*/
;*    hopjs-blank-line-p ...                                           */
;*---------------------------------------------------------------------*/
(defun hopjs-blank-line-p (pos)
  (interactive "d")
  (save-excursion
    (goto-char pos)
    (beginning-of-line)
    (looking-at "[ \t]*$")))

;*---------------------------------------------------------------------*/
;*    hopjs-same-line-p ...                                            */
;*---------------------------------------------------------------------*/
(defun hopjs-same-line-p (beg pos)
  (when (< beg pos)
    (save-excursion
      (goto-char beg)
      (move-end-of-line 1)
      (let ((eol (point)))
	(when (>= eol pos)
	  (goto-char pos)
	  (move-end-of-line 1)
	  (= (point) eol))))))

;*---------------------------------------------------------------------*/
;*    hopjs-close-paren-tag ...                                        */
;*---------------------------------------------------------------------*/
(defun hopjs-close-paren-tag ()
  "Close parenthesis or tag"
  (interactive)
  (let* ((pe (parse-partial-sexp
	      (point)
	      (save-excursion (hopjs-beginning-of-defun) (point))))
	 (bra (cadr pe))
	 (tag (when (hopjs-html-p (point)) (hopjs-find-opening-tag (point))))
	 (beg (match-beginning 0))
	 (end (match-end 0)))
    (cond
     ((and tag (or (not bra) (> end bra)))
      (cond
       ((hopjs-pos-eolp end)
	;; tag at the beginning of line
	(unless (hopjs-blank-line-p (point))
	  (indent-for-tab-command)
	  (insert "\n"))
	(insert "</" tag ">")
	(newline-and-indent))
       ((hopjs-pos-bolp beg)
	;; tag at the end of line
	(if (hopjs-same-line-p beg (point))
	    (insert "</" tag ">")
	  (progn
	    (unless (hopjs-blank-line-p (point))
	      (indent-for-tab-command)
	      (insert "\n"))
	    (insert "</" tag ">")
	    (newline-and-indent))))
       (t
	(insert "</" tag ">")
	(newline-and-indent))))
     ((> bra 0)
      ;; no opening tag
      (case (char-after (cadr pe))
	((?{)
	 (when (save-excursion (goto-char (cadr pe)) (looking-at "{[ \t]*$"))
	   (unless (hopjs-blank-line-p (point))
	     (newline-and-indent)))
	 (hopjs-electric-brace))
	((?\()
	 (when (save-excursion (goto-char (cadr pe)) (looking-at "[(][ \t]*$"))
	   (unless (hopjs-blank-line-p (point))
	     (newline-and-indent)))
	 (hopjs-electric-paren))
	((?\[) (insert "]")))))))

;*---------------------------------------------------------------------*/
;*    hopjs-indent-statement ...                                       */
;*---------------------------------------------------------------------*/
(defun hopjs-indent-statement ()
  "Indent curent statement."
  (interactive)
  (save-excursion
    (if (hopjs-opening-tag-p (point))
	(if (looking-at hopjs-re-special-tag)
	    (indent-according-to-mode)
	  (let ((beg (point)))
	    (if (hopjs-find-closing-tag (1+ (match-end 0)))
		(let ((end (match-end 0)))
		  (indent-region beg end))
	      (indent-according-to-mode))))
      (progn
	(c-beginning-of-statement
	 0
	 (save-excursion
	   (hopjs-beginning-of-defun)
	   (point))
	 nil)
	(let ((start (point)))
	  (c-forward-sexp)
	  (let ((end (point)))
	    (indent-region start end)))))))

;*---------------------------------------------------------------------*/
;*    hopjs-return ...                                                 */
;*---------------------------------------------------------------------*/
(defun hopjs-return (&optional dummy)
  "On indent automatiquement sur un RET.
usage: (js-return)  -- [RET]"
  (interactive)
  (newline)
  (hopjs-auto-indent))

;*---------------------------------------------------------------------*/
;*    hopjs-in-string-comment-p ...                                    */
;*---------------------------------------------------------------------*/
(defun hopjs-in-string-comment-p (pos)
  (memq (get-text-property pos 'face)
	'(font-lock-comment-face font-lock-string-face)))

;*---------------------------------------------------------------------*/
;*    hopjs-eol-pos ...                                                */
;*---------------------------------------------------------------------*/
(defun hopjs-eol-pos ()
  (save-excursion
    (end-of-line)
    (point)))
  
;*---------------------------------------------------------------------*/
;*    hopjs-html-p ...                                                 */
;*---------------------------------------------------------------------*/
(defun hopjs-html-p (pos)
  (interactive "d")
  (unless (hopjs-in-string-comment-p pos)
    (save-excursion
      (hopjs-parse-start pos)
      (letn loop ()
	    (case (hopjs-parse-peek-token-type)
	      ((text ident dots)
	       (hopjs-parse-consume-token-any)
	       (funcall loop))
	      ((rbrace rparen)
	       (hopjs-parse-backward-sexp)
	       (unless (eq (hopjs-parse-peek-token-type) 'dollar)
		 (funcall loop)))))
       (memq (hopjs-parse-peek-token-type) '(otag ctag dollar >)))))

;*---------------------------------------------------------------------*/
;*    hopjs-search-code-regexp ...                                     */
;*---------------------------------------------------------------------*/
(defun hopjs-search-code-regexp (regexp search key)
  (save-excursion
    (let ((res '_)
	  (pos (point)))
      (while (eq res '_)
	(if (funcall search regexp nil t)
	    (let ((beg (match-beginning 0)))
	      (cond
	       ((eq (get-text-property beg 'face) key)
		(setq res t))
	       ((> pos (point))
		;; backward search
		(if (> (point) (point-min))
		    (goto-char (1- beg))
		  (setq res nil)))
	       (t
		;; forward search
		(if (< (point) (point-max))
		    (forward-char)
		  (setq res nil)))))
	  (setq res nil)))
      res)))
      
;*---------------------------------------------------------------------*/
;*    hopjs-search-previous-function ...                               */
;*---------------------------------------------------------------------*/
(defun hopjs-search-previous-function ()
  (when (hopjs-search-code-regexp
	 "\\_<\\(function\\|service\\)\\_>"
	 're-search-backward 
	 'font-lock-keyword-face)
    (let ((beg (match-beginning 0)))
      (goto-char beg)
      (if (hopjs-search-code-regexp "{" 're-search-forward nil)
	  ;; and we have found a open bracket
	  (condition-case nil
	      (progn
		(goto-char (match-beginning 0))
		(forward-sexp 1)
		(cons beg (point)))
	    (error
	     (cons beg beg)))
	;; no bracket found...
	nil))))

;*---------------------------------------------------------------------*/
;*    hopjs-goto-defun ...                                             */
;*---------------------------------------------------------------------*/
(defun hopjs-goto-defun (ref pos)
  (let ((loop t))
    (while loop
      (let ((fun (hopjs-search-previous-function)))
	(cond
	 ((not fun)
	  (goto-char (point-min))
	  (setq loop nil))
	 ((> (cdr fun) pos)
	  (progn
	    (setq loop nil)
	    (goto-char (funcall ref fun))))
	 ((> (car fun) (point-min))
	  (goto-char (1- (car fun))))
	 (t
	  (setq loop nil)))))))

;*---------------------------------------------------------------------*/
;*    hopjs-beginning-of-defun ...                                     */
;*---------------------------------------------------------------------*/
(defun hopjs-beginning-of-defun (&optional arg)
  (unless arg (setq arg 1))
  (while (> arg 0)
    (setq arg (1- arg))
    (hopjs-goto-defun 'car (point))))

;*---------------------------------------------------------------------*/
;*    hopjs-end-of-defun ...                                           */
;*---------------------------------------------------------------------*/
(defun hopjs-end-of-defun (&optional arg)
  (unless arg (setq arg 1))
  (while (> arg 0)
    (setq arg (1- arg))
    (hopjs-goto-defun 'cdr (point))))

;*---------------------------------------------------------------------*/
;*    hopjs-unhighlight-tags ...                                       */
;*---------------------------------------------------------------------*/
(defun hopjs-unhighlight-tags ()
  (while (consp hopjs-tag-overlays)
    (delete-overlay (car hopjs-tag-overlays))
    (setq hopjs-tag-overlays (cdr hopjs-tag-overlays))))

;*---------------------------------------------------------------------*/
;*    hopjs-highlight-tag ...                                          */
;*---------------------------------------------------------------------*/
(defun hopjs-highlight-tag (face beg end)
  (let ((ov (make-overlay beg end nil t nil)))
    (overlay-put ov 'face face)
    (overlay-put ov 'hopjs-tag-overlay t)
    (overlay-put ov 'evaporate t)
    (setq hopjs-tag-overlays (cons ov hopjs-tag-overlays))))

;*---------------------------------------------------------------------*/
;*    hopjs-closing-tag-p ...                                          */
;*---------------------------------------------------------------------*/
(defun hopjs-closing-tag-p (pos)
  (when (and (eq (char-after pos) ?>)
	     (> pos (+ 1 (point-min)))
	     (not (eq (char-after (1- pos)) ?/)))
    (save-excursion
      (when (search-backward "<" nil t 1)
	(and (looking-at hopjs-re-close-tag)
	     (= (match-end 0) (1+ pos)))))))

;*---------------------------------------------------------------------*/
;*    hopjs-opening-tag-p ...                                          */
;*---------------------------------------------------------------------*/
(defun hopjs-opening-tag-p (pos)
  (when (and (eq (char-after pos) ?<) (< pos (- (point-max) 1)))
    (save-excursion
      (when (looking-at hopjs-re-open-tag)
	(let ((tag (buffer-substring-no-properties
		    (match-beginning 1) (match-end 1))))
	  (not (member tag hopjs-special-tags)))))))

;*---------------------------------------------------------------------*/
;*    hopjs-find-opening-tag ...                                       */
;*---------------------------------------------------------------------*/
(defun hopjs-find-opening-tag (pos)
  (save-excursion
    (goto-char pos)
    (let ((depth 1)
          (res 'loop))
      (while (eq res 'loop)
        (if (re-search-backward hopjs-re-any-tag nil t 1)
            (progn
              (unless (hopjs-in-string-comment-p (match-beginning 0))
                (cond
                 ((looking-at hopjs-re-end-tag)
                  ;; we still have to check stand alone tag that are confused
                  ;; with closing tar parts during the re-search
                  (if (save-excursion
                        (goto-char (+ (point) 2))
                        (let ((pt (point)))
                          (when (re-search-backward
                                 hopjs-re-standalone-tag nil t 1)
                            (= (match-end 0) pt))))
                      (goto-char (match-beginning 0))
                    (setq depth (1+ depth))))
                 ((looking-at hopjs-re-close-tag)
                  (setq depth (1+ depth)))
                 (t
                  (looking-at hopjs-re-open-tag)
                  (unless (member (buffer-substring-no-properties
                                   (match-beginning 1) (match-end 1))
                                  hopjs-special-tags)
                    (if (= depth 1)
                        (setq res 
                              (buffer-substring-no-properties
                               (match-beginning 1) (match-end 1)))
                      (setq depth (1- depth))))))))
          (setq res nil)))
      ;; update the match-beginning math-end cache with the proper open tag
      (goto-char (match-beginning 0))
      (looking-at "[^ \t\n]+")
      res)))

;*---------------------------------------------------------------------*/
;*    hopjs-find-closing-tag ...                                       */
;*---------------------------------------------------------------------*/
(defun hopjs-find-closing-tag (pos)
  (save-excursion
    (goto-char pos)
    (let ((depth 1)
	  (res 'loop))
      (while (eq res 'loop)
	(if (re-search-forward hopjs-re-any-tag nil t 1)
	    (let ((beg (match-beginning 0))
		  (end (match-end 0)))
	      (unless (hopjs-in-string-comment-p beg)
		(goto-char beg)
		(cond
		 ((looking-at hopjs-re-standalone-tag)
		  (setq end (match-end 0))
		  nil)
		 ((looking-at hopjs-re-open-tag)
		  (unless (member (buffer-substring-no-properties
				   (match-beginning 1) (match-end 1))
				  hopjs-special-tags)
		    (setq depth (1+ depth))))
		 ((looking-at hopjs-re-end-tag)
		  (if (= depth 1)
		      (setq res 'tag)
		    (setq depth (1- depth))))
		 (t
		  (if (= depth 1)
		      (progn
			(looking-at hopjs-re-close-tag)
			(setq res 
			      (buffer-substring-no-properties
			       (match-beginning 1) (match-end 1))))
		    (setq depth (1- depth))))))
	      (goto-char end))
	  (setq res nil)))
      res)))

;*---------------------------------------------------------------------*/
;*    hopjs-tag-matching ...                                           */
;*---------------------------------------------------------------------*/
(defun hopjs-tag-matching ()
  (interactive)
  (hopjs-unhighlight-tags)
  (cond
   ((hopjs-in-string-comment-p (point))
    nil)
   ((hopjs-closing-tag-p (1- (point)))
    (if (> (point) 3)
	(let* ((beg (match-beginning 1))
	       (end (match-end 1))
	       (tag (buffer-substring-no-properties beg end))
	       (otag (hopjs-find-opening-tag beg)))
	  (cond
	   ((not otag)
	    (hopjs-highlight-tag 'hopjs-nomatch-face beg end))
	   ((string-equal tag otag)
	    (hopjs-highlight-tag
	     'hopjs-match-face beg end)
	    (hopjs-highlight-tag
	     'hopjs-match-face (match-beginning 0) (match-end 0)))
	   (t
	    (hopjs-highlight-tag
	     'hopjs-nomatch-face beg end)
	    (hopjs-highlight-tag
	     'hopjs-nomatch-face (match-beginning 1) (match-end 1)))))
      (hopjs-unhighlight-tags)))
   ((hopjs-opening-tag-p (point))
    (cond
     ((looking-at hopjs-re-standalone-tag)
      (hopjs-unhighlight-tags))
     ((< (point) (- (point-max) 3))
      (let* ((tag (buffer-substring-no-properties
		   (match-beginning 1) (match-end 1)))
	     (beg (match-beginning 1))
	     (end (match-end 1))
	     (otag (hopjs-find-closing-tag (match-end 0))))
	(cond
	 ((not otag)
	  (hopjs-highlight-tag 'hopjs-nomatch-face beg end))
	 ((eq otag 'tag)
	  t)
	 ((string-equal tag otag)
	  (hopjs-highlight-tag 'hopjs-match-face beg end)
	  (hopjs-highlight-tag
	   'hopjs-match-face (match-beginning 1) (match-end 1)))
	 (t
	  (hopjs-highlight-tag 'hopjs-nomatch-face beg end)
	  (hopjs-highlight-tag
	   'hopjs-nomatch-face (match-beginning 1) (match-end 1))))))
     (t
      (hopjs-unhighlight-tags))))
   (t
    (hopjs-unhighlight-tags))))

;*---------------------------------------------------------------------*/
;*    hopjs-forward-sexp ...                                           */
;*---------------------------------------------------------------------*/
(defun hopjs-forward-sexp ()
  (if (hopjs-opening-tag-p (point))
      (if (looking-at hopjs-re-standalone-tag)
	  (goto-char (match-end 0))
	(let ((otag (hopjs-find-closing-tag (+ 1 (match-end 0)))))
	  (if otag
	      (goto-char (match-end 0))
	    (let ((forward-sexp-function nil))
	      (forward-sexp 1)))))
    (let ((forward-sexp-function nil))
      (forward-sexp 1))))

;*---------------------------------------------------------------------*/
;*    hopjs-backward-sexp ...                                          */
;*---------------------------------------------------------------------*/
(defun hopjs-backward-sexp ()
  (if (hopjs-closing-tag-p (1- (point)))
      (let ((otag (hopjs-find-opening-tag (match-beginning 0))))
	(if otag
	    (goto-char (match-beginning 0))
	  (let ((backward-sexp-function nil))
	    (forward-sexp -1))))
    (let ((forward-sexp-function nil))
      (forward-sexp -1))))

;*---------------------------------------------------------------------*/
;*    forward-sexp-function ...                                        */
;*---------------------------------------------------------------------*/
(make-variable-buffer-local 'forward-sexp-function)

(setq forward-sexp-function
      #'(lambda (arg)
	  (interactive)
	  (cond
	   ((= arg 1)
	    (hopjs-forward-sexp))
	   ((= arg -1)
	    (hopjs-backward-sexp))
	   (t 
	    (let ((forward-sexp-function nil))
	      (forward-sexp arg))))))

;*---------------------------------------------------------------------*/
;*    hopjs doc index                                                  */
;*---------------------------------------------------------------------*/
(defvar hopjs-doc-index-table
  (make-vector 27 '()))

(defvar hopjs-doc-indexes
  '())

;*---------------------------------------------------------------------*/
;*    hopjs-doc-load-indexes ...                                       */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-load-indexes ()
  (hopjs-doc-load-index
   "hop"
   (concat hopjs-doc-dir "/idx.json")
   hopjs-doc-dir hopjs-doc-index-table)
  (hopjs-doc-load-index
   "html"
   (concat hopjs-doc-dir "/html-idx.json")
   hopjs-html-doc-url hopjs-doc-index-table)
  (hopjs-doc-load-index
   "mdn"
   (concat hopjs-doc-dir "/mdn-idx.json")
   hopjs-mdn-doc-url hopjs-doc-index-table)
  (hopjs-doc-load-index
   "node"
   (concat hopjs-doc-dir "/node-idx.json")
   hopjs-node-doc-url hopjs-doc-index-table)
  (mapc 'hopjs-doc-load-repo-indexes hopjs-doc-extra-dir))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-load-repo-indexes ...                                  */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-load-repo-indexes (p)
  ;; load all the idx.json files located in XXX/doc directory under P
  (let ((path (expand-file-name p)))
    (when (file-directory-p path)
      (mapc #'(lambda (d)
		(unless (string-equal d "..")
		  (let* ((dir (concat path "/" d "/doc"))
			 (idx (concat dir "/idx.json")))
		    (when (file-exists-p idx)
		      (hopjs-doc-load-index
		       d
		       idx (concat "file://" dir)
		       hopjs-doc-index-table)))))
	    (directory-files path)))))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-load-node-modules-indexes ...                          */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-load-node-modules-indexes ()
  (let ((dir default-directory)
	(count 5))
    (while (and (file-directory-p dir) (not (equal dir "//")) (> count 0))
      (let ((nm (concat dir "node_modules")))
	(when (file-directory-p nm) (hopjs-load-repo-indexes nm))
	(setq dir (expand-file-name (concat dir "../")))
	(setq count (1- count))))
    (let ((nm (expand-file-name "~/.node_modules")))
      (when (file-directory-p nm)
	(hopjs-load-repo-indexes nm)))))
  
;*---------------------------------------------------------------------*/
;*    hopjs-doc-load-index ...                                         */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-load-index (title file base table)
  (unless (member title hopjs-doc-indexes)
    (when (file-exists-p file)
      (message "hopjs.el: loading index %s" file)
      (setq hopjs-doc-indexes (cons title hopjs-doc-indexes))
      (let* ((i 0)
	     (v (json-read-file file))
	     (len (length v)))
	(while (< i len)
	  (let* ((en (aref v i))
		 (k (assq 'key en))
		 (y (assq 'type en))
		 (n (string-match (cdr k) "[^.]+$"))
		 (c (aref (cdr k) (or n 0)))
		 (m (cond
		     ((and (>= c ?A) (<= c ?Z)) (- c ?A))
		     ((and (>= c ?a) (<= c ?z)) (- c ?a))
		     (t 26))))
	    (when (and (consp y) (or (string-equal (cdr y) "tag") (string-equal (cdr y) "module")))
	      (rplacd k (downcase (cdr k))))
	    (when base
	      (let ((c (assq 'url en)))
		(when (consp c)
		  (rplacd c (concat base "/" (cdr c))))))
	    (let* ((bucket (aref table m))
		   (old (assoc (cdr k) bucket)))
	      (if old
		  (rplacd old (cons en (cdr old)))
		(aset table m (cons (cons (cdr k) (list en)) (aref table m)))))
	    (setq i (+ i 1))))))))
	
;*---------------------------------------------------------------------*/
;*    hopjs-doc-index-find ...                                         */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-index-find (word table)
  (when (> (length word) 0)
    (let* ((key (aref word 0))
	   (idx (cond
		 ((and (>= key ?a) (<= key ?z)) (- key ?a))
		 ((and (>= key ?A) (<= key ?Z)) (- key ?A))
		 (t 26)))
	   (bucket (aref table idx)))
      (assoc word bucket))))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-word ...                                               */
;*---------------------------------------------------------------------*/
(defvar hopjs-doc-point 1)
(defvar hopjs-doc-url nil)
(defvar hopjs-doc-url-title nil)
(defvar hopjs-doc-beg nil)
(defvar hopjs-doc-end nil)

(make-variable-buffer-local 'hopjs-doc-point)
(make-variable-buffer-local 'hopjs-doc-url)
(make-variable-buffer-local 'hopjs-doc-url-title)
(make-variable-buffer-local 'hopjs-doc-beg)
(make-variable-buffer-local 'hopjs-doc-end)

;*---------------------------------------------------------------------*/
;*    backward-hopjs-expr ...                                          */
;*---------------------------------------------------------------------*/
(defun backward-hopjs-expr ()
  (when (> (point) (point-min))
    (backward-word)
    (case (char-after (- (point) 1))
      ((?.) (backward-hopjs-expr))
      ((?<) (goto-char (- (point) 1)) (point))
      (t (point)))))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-at-point ...                                           */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-at-point (pos)
  (interactive "d")
  (save-excursion
    (unless (hopjs-in-string-comment-p (point))
      (let* ((beg (if (eq (char-after (1- (point))) ?<)
		      (point)
		    (progn (backward-word) (point))))
	     (end (progn (forward-word 1) (point)))
	     (word (buffer-substring-no-properties beg end))
	     (y "*"))
	(when (>= end pos)
	  (cond
	   ((progn (backward-hopjs-expr) (looking-at hopjs-re-open-tag))
	    ;; a tag
	    (setq y "tag")
	    (setq word (downcase word)))
	   ((and (> (point) 2)
		 (progn (goto-char (- beg 2)) (looking-at hopjs-re-close-tag)))
	    ;; a tag
	    (setq y "tag")
	    (setq word (downcase word)))
	   ((progn (goto-char (1+ end)) (looking-at "[ \t\n]*[=,;}]"))
	    (setq y "parameter"))
	   ((progn (goto-char (- beg 4)) (looking-at "new "))
	    ;; a constructor
	    (setq y "constructor")))
	  (cond
	   ((string-equal word "")
	    (hopjs-doc-undoc))
	   ((not (= (point) hopjs-doc-point))
	    (setq hopjs-doc-point (point))
	    (hopjs-doc-undoc)
	    (setq hopjs-doc-beg beg)
	    (setq hopjs-doc-end end)
	    (let ((entry (hopjs-doc-index-find word hopjs-doc-index-table)))
	      (let ((urls '())
		    (tooltip nil))
		(setq hopjs-doc-url-title word)
		(setq hopjs-doc-url '())
		(while (consp entry)
		  (let* ((en (car (cdr entry)))
			 (type (assq 'type en)))
		    (setq entry (cdr entry))
		    (if (or (not (consp type))
			    (string-equal (cdr type) y)
			    (and (not (string-equal (cdr type) "tag"))
				 (string-equal y "*"))
			    (and (string-equal (cdr type) "function")
				 (string-equal y "constructor")))
			(let ((url (assq 'url en)))
			  (when url
			    (let* ((proto (assq 'proto en))
				   (tip (replace-regexp-in-string
					 "&gt;" ">"
					 (replace-regexp-in-string
					  "&lt;" "<" (cdr proto)))))
			      (setq urls (cons (cons tip (cdr url)) urls))
			      (setq tooltip
				    (if tooltip
					(concat tip "\n" tooltip)
				      tip))))))))
		(when (consp urls)
		  (if (consp (cdr urls))
		      (setq hopjs-doc-url urls)
		    (setq hopjs-doc-url (cdr (car urls))))
		  (let ((mod (buffer-modified-p)))
		    (put-text-properties beg end
					 'keymap hopjs-tooltip-map
					 'face 'highlight
					 'help-echo tooltip)
		    (set-buffer-modified-p mod))))))))))))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-undoc ...                                              */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-undoc ()
  (when hopjs-doc-beg
    (let ((mod (buffer-modified-p))
	  (l '(help-echo mouse-face keymap)))
      (while (consp l)
	(remove-text-property hopjs-doc-beg hopjs-doc-end (car l))
	(setq l (cdr l)))
      (set-buffer-modified-p mod))))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-browse-url ...                                         */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-browse-url (url)
  (let ((cmd (concat hopjs-navigator " " url)))
    (message cmd)
    (start-process "system" nil "sh" "-c" cmd)))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-entry ...                                              */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-entry (point)
  (interactive "d")
  (cond
   ((eq point 0)
    (hopjs-doc-browse-url hopjs-official-doc-url))
   ((consp hopjs-doc-url)
    (popup-menu (cons
		 hopjs-doc-url-title
		 (cons
		  "--single-line"
		  (mapcar #'(lambda (e)
			      (vector (car e)
				      (list 'hopjs-doc-browse-url (cdr e))
				      :help
				      (cdr e)))
			  hopjs-doc-url)))))
   ((posix-string-match "http[s]?://" hopjs-doc-url)
    (hopjs-doc-browse-url  hopjs-doc-url))
   ((eq (aref hopjs-doc-url 0) ?/)
    (hopjs-doc-browse-url (format "file://%s" hopjs-doc-url)))
   (t 
    (hopjs-doc-browse-url (format "file://%s/%s" hopjs-doc-dir hopjs-doc-url)))))

;*---------------------------------------------------------------------*/
;*    hopjs-doc-mode-line ...                                          */
;*---------------------------------------------------------------------*/
(defun hopjs-doc-mode-line ()
  (let ((keymap (make-sparse-keymap)))
    
    (define-key keymap [mode-line mouse-1]
      (lambda (e)
	(interactive "e")
	(let* ((win (get-buffer-window))
	       (x (- (window-pixel-width win) 200))
	       (y (- (window-pixel-height win) 250)))
	  (message "WIN=%s" win)
	  (popup-menu (cons
		       "documentation"
		       (cons
			"--single-line"
			(mapcar #'(lambda (e)
				    (vector (car e)
					    (list 'hopjs-doc-browse-url (cdr e))
					    :help
					    (cdr e)))
				hopjs-external-docs)))
		      (popup-menu-normalize-position
		       `((,x ,y) ,win))))))
    
    (define-key keymap [mode-line mouse-2]
      (lambda (e)
	(interactive "e")
	(hopjs-doc-at-point (point))
	(hopjs-doc-entry (point))))
    
    (propertize
     "  doc  " 'help-echo "mouse-1: all documentations, mouse-2 local documentation"
     'face '(:height 90 :background "orange" :foreground "lightgrey" :weight bold)
     'mouse-face '(:background "orange" :foreground "white" :weight bold)
     'keymap keymap)))

;*---------------------------------------------------------------------*/
;*    hopjs-dls-init ...                                               */
;*---------------------------------------------------------------------*/
(defun hopjs-dls-init ()
  (save-excursion
    (goto-char (point-min))
    (while (progn
	     (hopjs-dls-skip-comment)
	     (looking-at "^[\"']use[ \t]+\\([^\"']+\\)[\"'][;]?$"))
      (let ((lang (buffer-substring-no-properties
		   (match-beginning 1) (match-end 1))))
	(hopjs-dls-load-node-modules lang)
	(next-line 1)
	(beginning-of-line)))))

;*---------------------------------------------------------------------*/
;*    hopjs-dls-skip-comment ...                                       */
;*---------------------------------------------------------------------*/
(defun hopjs-dls-skip-comment ()
  (while (looking-at "//.*$\\|/[*]\\(?:[^*]\\|[*][^/]\\)*[*]/")
    (goto-char (min (point-max) (1+ (match-end 0))))))
   
;*---------------------------------------------------------------------*/
;*    hopjs-dls-load-node-modules ...                                  */
;*---------------------------------------------------------------------*/
(defun hopjs-dls-load-node-modules (lang)
  (let ((dir default-directory)
	(count 5))
    (while (and (file-directory-p dir) (not (equal dir "//")) (> count 0))
      (if (hopjs-dls-load-dir lang (concat dir "node_modules"))
	  (setq count -10))
      (progn
	(setq dir (expand-file-name (concat dir "../")))
	(setq count (1- count))))
    (when (= count 0)
      (hopjs-dls-load-dir lang (expand-file-name (concat "~/.node_modules"))))))
  
;*---------------------------------------------------------------------*/
;*    hopjs-dls-load-dir ...                                           */
;*---------------------------------------------------------------------*/
(defun hopjs-dls-load-dir (lang base)
  (let ((res nil))
    ;; check emacs file
    (let ((el (concat base "/" lang "/etc/hopjs-" lang ".el")))
      (when (file-exists-p el) (load-library el) (setq res t)))
    ;; check documentation file
    (let ((doc (concat base "/" lang "/doc/index.html")))
      (when (file-exists-p doc)
	(setq hopjs-external-docs
	      (append hopjs-external-docs
		      (list (cons lang (concat "file://" doc)))))
	(setq res t)))
    res))

;*---------------------------------------------------------------------*/
;*    hopjs-load-repo-indexes ...                                      */
;*---------------------------------------------------------------------*/
(defun hopjs-load-repo-indexes (p)
  ;; load all the idx.json files located in XXX/doc directory under P
  (let ((path (expand-file-name p)))
    (when (file-directory-p path)
      (mapc #'(lambda (d)
		(unless (string-equal d "..")
		  (let* ((dir (concat path "/" d "/doc"))
			 (idx (concat dir "/idx.json")))
		    (when (file-exists-p idx)
		      (hopjs-doc-load-index
		       d
		       idx (concat "file://" dir)
		       hopjs-doc-index-table)))))
	    (directory-files path)))))

;*---------------------------------------------------------------------*/
;*    hopjs-load-node-modules-indexes ...                              */
;*---------------------------------------------------------------------*/
(defun hopjs-load-node-modules-indexes ()
  (let ((dir default-directory)
	(count 5))
    (while (and (file-directory-p dir) (not (equal dir "//")) (> count 0))
      (let ((nm (concat dir "node_modules")))
	(when (file-directory-p nm) (hopjs-load-repo-indexes nm))
	(setq dir (expand-file-name (concat dir "../")))
	(setq count (1- count))))
    (let ((nm (expand-file-name "~/.node_modules")))
      (when (file-directory-p nm)
	(hopjs-load-repo-indexes nm)))))
  
;*---------------------------------------------------------------------*/
;*    hopjs-post-command-hook ...                                      */
;*---------------------------------------------------------------------*/
(defun hopjs-post-command-hook ()
  (interactive)
  (unless (eq this-command 'mouse-drag-region)
    (condition-case nil
	(hopjs-tag-matching)
      (error
       (message "ERROR in tag-matching")))
    (condition-case nil
	(hopjs-doc-at-point (point))
      (error
       (message "ERROR in DOC")))))

(defun mode-line-fill (face reserve)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (unless reserve
    (setq reserve 20))
  (when (and window-system (eq 'right (get-scroll-bar-mode)))
    (setq reserve (- reserve 3)))
  (propertize
   " "
   'display `((space :align-to (- (+ right right-fringe right-margin) ,reserve)))))
;*    'face face))                                                     */

;*---------------------------------------------------------------------*/
;*    hopjs-mode-line-format ...                                       */
;*---------------------------------------------------------------------*/
(defun hopjs-mode-line-format ()
  (let* ((flm (reverse mode-line-format))
	 (flm-sans-fill (if (equal (car flm) "-%-")
			    (cdr flm)
			  flm)))
    (reverse
     (cons (hopjs-doc-mode-line)
	   (cons (mode-line-fill 'mode-line 10)
		 flm-sans-fill)))))

;* (defun hopjs-mode-line-format ()                                    */
;*   (cons (car mode-line-format)                                      */
;* 	(cons (cadr mode-line-format)                                  */
;* 	      (cons "-"                                                */
;* 		    (cons (hopjs-doc-mode-line)                        */
;* 			  (append (cddr mode-line-format)              */
;* 				  (list (mode-line-fill 'mode-line 10) */
;* 					"foo")))))))                   */



;*---------------------------------------------------------------------*/
;*    hopjs-key-bindings ...                                           */
;*---------------------------------------------------------------------*/
(defun hopjs-key-bindings ()
  (let ((map (current-local-map)))
    (define-key map "\C-m" 'hopjs-return)
    (local-unset-key "\ee")
    (define-key map "\e\C-q" 'hopjs-indent-statement)
    (local-unset-key "}")
    (define-key map "}" 'hopjs-electric-brace)
    (local-unset-key ")")
    (define-key map ")" 'hopjs-electric-paren)
    (local-unset-key ">")
    (define-key map ">" 'hopjs-electric-abra)
    (define-key map "\C-c\C-c" 'hopjs-close-paren-tag)))

;*---------------------------------------------------------------------*/
;*    tooltip ...                                                      */
;*---------------------------------------------------------------------*/
(defvar hopjs-tooltip-map (make-sparse-keymap))
;; mouse-2
(define-key hopjs-tooltip-map[(mouse-2)]
  (function hopjs-doc-entry))

;*---------------------------------------------------------------------*/
;*    hopjs-old-indent-function ...                                    */
;*---------------------------------------------------------------------*/
(defvar hopjs-old-indent-function '())

;*---------------------------------------------------------------------*/
;*    hopjs-auto-indent ...                                            */
;*---------------------------------------------------------------------*/
(defun hopjs-auto-indent ()
  (interactive)
  (cond
   (hopjs-indent-custom
    (let ((ccol (current-column))
	  (mov '())
	  (ocol 0))
      (beginning-of-line)
      (let ((icol (hopjs-indent (point))))
	(when icol
	  (beginning-of-line)
	  (when (looking-at "[ \t]+")
	    (let* ((p (point))
		   (b (match-beginning 0))
		   (e (match-end 0)))
	      (goto-char e)
	      (setq ocol (current-column))
	      (cond
	       ((= ocol icol)
		(if (< ccol icol)
		    (setq mov icol)
		  (setq mov ccol)))
	       ((> icol ocol)
		(if (< ccol ocol)
		    (setq mov icol)
		  (setq mov (+ icol (- ccol ocol)))))
	       (t
		(delete-region b e)
		(if (< ccol ocol)
		    (setq mov icol)
		  (setq mov (+ icol (- ccol ocol))))))))
	  (indent-to icol)
	  (beginning-of-line)
	  (cond
	   ((= ccol 0)
	    (when (looking-at "[ \t]+")
	      (goto-char (match-end 0))))
	   (mov
	    (line-move-to-column mov))
	   ((> ccol 0)
	    (cond
	     ((and (= ocol 0) (> icol 0))
	      (end-of-line)
	      (re-search-backward "[^ \t]")
	      (goto-char (+ 1 (match-beginning 0)))
	      (delete-region (+ 1 (match-beginning 0)) (match-end 0)))
	     ((< ccol icol)
	      (line-move-to-column ccol))
	     (t
	      (line-move-to-column ccol)))))))))
   ((hopjs-old-indent-function)
    (funcall hopjs-old-indent-function))))

;*---------------------------------------------------------------------*/
;*    hopjs-mode-hook ...                                              */
;*---------------------------------------------------------------------*/
(defun hopjs-mode-hook ()
  ;; indent
  (setq hopjs-old-indent-function indent-line-function)
  (setq indent-line-function 'hopjs-auto-indent)
  ;; syntax
  (hopjs-syntax)
  ;; key bindings
  (hopjs-key-bindings)
  ;; font lock
  (font-lock-add-keywords nil hopjs-font-lock-keywords)
  ;; custom beginning of defun
  ;; dls (e.g., hiphop) init
  (hopjs-dls-init)
  ;; delayed doc index load (for quick start)
  (run-at-time "1 sec" nil 'hopjs-doc-load-indexes)
  (run-at-time "2 sec" nil 'hopjs-doc-load-node-modules-indexes)
  ;; tag matching
  (add-hook 'post-command-hook (function hopjs-post-command-hook) t t)
  ;; mode line format for on-line documentations
  (when hopjs-mode-line-doc-button-p
    (setq mode-line-format (hopjs-mode-line-format))
    (force-mode-line-update t))
  ;; user hooks
  (run-hooks 'hopjs-mode-hook))

;*---------------------------------------------------------------------*/
;*    init                                                             */
;*---------------------------------------------------------------------*/
;; (autoload 'hopjs-mode-hook "hopjs" "Hop.js javascript mode hook" t)
;; (add-hook 'js-mode-hook 'hopjs-mode-hook)