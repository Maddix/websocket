#!/usr/bin/env newlisp

# #############################################################################
# Lists & Strings

;; Return the list with last removed
;; (first-body '(a b c d)) -> (a b c)
;; (first-body '(a b)) -> (a)
;; (first-body '()) -> ()
;; Phase this out as (-1 lst) does the same thing
(define (first-body lst)
	(unless (empty? lst) (pop lst -1))
	lst)

;; Get the body of a list ignoring the first and last items.
;; (body (list a b c d)) -> (b c)
;; Phase this out as (1 -1 lst) does the same thing only better
(define (body lst)
	(rest (first-body lst)))

;; (zip (list 'a 'b 'c) (list 1 2 3)) -> ((a 1) (b 2) (c 3))
;; (zip (list 'a 'b) (list 1 2 3)) -> ((a 1) (b 2))
;; (zip (list 'a 'b 'c) (list 1 2)) -> ((a 1) (b 2) (c nil))
(define (zip lstx lsty)
	(map pair lstx lsty))

;; (pair 1 2) -> (1 2)
;; (pair 1 2 3) -> (1 2)
;; (pair 1) -> (1 nil)
;; (pair) -> (nil nil)
(define (pair x y)
	(list x y))

;; (pop-times lst times)
;; Calls pop on lst x number of times.
;; (setq i (1 2 3 4 5 6 7 8))
;; (pop-times i 3) -> (1 2 3)
;; (pop-times i 7) -> (4 5 6 7 8 nil nil)
;; (pop-times i 3) -> (nil nil nil)
(context 'pop-times) ; (pop-times list int) -> (pop-times lst 2) -> ((pop lst) (pop lst))
(define-macro (pop-times:pop-times)
	(letex (lst ((args) 0) times ((args) 1))
		(map eval (dup (list 'pop 'lst) times))))
(context MAIN)

;; Do I really need this? Its just like zip.
;; (pair-lst sym .. list)
;; For every sym listed a item from list will be assigned, if there are more
;; syms then items then nil will be assigned, if there are more items then not
;; all of them will be used.
;; Examples:
;; (pair-lst x y z '(a b c)) ->
;;		((x a) (y b) (z c))
;; (pair-lst a b c '((+ 1 2) y (list 1 2 3))) ->
;;		((a (+ 1 2)) (b y) (c (list 1 2 3)))
;; (pair-lst a b c '(1)) ->
;;		((a 1) (b nil) (c nil))
;; (pair-lst a b c)
(define-macro (pair-lst)
	(when (is or list? string? (eval (last (args))))
		(zip (first-body (unquote (args))) (eval (last (args))))))

(define (get idx lst)
    (when (and (< idx (length lst)) (< 0 idx)) (lst idx)))

; lst - list of quoted items
; This doesn't handle infinitly quoted stuff like '''''a. :/
;; (unquote (list ''a ''b ''c)) -> (a b c)
;; (unquote '()) -> ()
;; (unquote) -> Error
(define (unquote lst)
	(map (fn (x) (if (quote? x) (eval x) x)) lst))

;; Returns the list split in half
(define (split lst idx)
	(letn (len (length lst) norm (if (< idx 0) (+ len idx) idx))
		(if (find norm (list 0 len))
			(list lst)
			(list (select lst (sequence 0 (- norm 1))) (select lst (sequence norm (-- len)))))))

(define (list-depth lst (depth 0))
    (flat (map
        (fn (item)
            (if (list? item)
                (list-depth item (+ 1 depth))
                depth)) lst)))

;; Not my best but it does work. Need some reworking.
;; (a b c (d e (f g) h) ((i (j k) l) m) n o p (q)) ->
;; ((a b c) (d e) (f g) (h) (i) (j k) (l) (m) (n o p) (q))
(define (seperate-groups lst , (main '()) (group '()))
	(let (flush-group (fn () (unless (empty? group) (push group main -1) (setq group '()))))
		(dolist (item lst)
			(if (list? item)
				(begin (flush-group) (extend main (list-groups item)))
				(push item group -1)))
		(flush-group))
	main)

(define (list-normalize lst , (group '()))
	(dolist (item lst)
		(let (pro-item (if (list? item) (list-normalize item) item))
			(unless (and (list? pro-item) (empty? pro-item)) (push pro-item group -1))))
	(if (and (= 1 (length group)) (list? (first group)))
		(first group)
		group))

;; Iterate over a list and collect each result.
;; Works the same as dolist
;; (docollect (item (list 1 2 3)) (+ 1 item)) -> (2 3 4)
(context 'docollect)
(define-macro (docollect:docollect)
	(let (result '())
		(letex (sym-lst (args 0) body (args 1))
			(dolist sym-lst (push body result -1)))
	result))
(context MAIN)


# #############################################################################
# Flow Logic

(context 'letup)
(define-macro (letup:letup)
	(eval (letex (
		;expressions (apply MAIN:pair-lst
		;	(push (eval (last (args 0)))
		;		(MAIN:first-body (args 0)) -1))

		expressions (MAIN:zip (MAIN:first-body (MAIN:unquote (args 0))) (eval (last (args 0))))
		body (args 1))
		;; --
		'(let expressions body))))
(context 'MAIN)

;; (is or list? string? "Hi how are you?") -> true
;; (is and integer? even? 2) -> true
;; (is or list? integer? "I am not.") -> nil
;; (is not list? float? "I am not.") -> true
(define (is)
	(let (op (first (args)) func-lst (body (args)) item (last (args)))
		(apply op (map (fn (func) (func item)) func-lst))))

;; Not sure I need this.
(define (str-bool str)
    (if (empty? str) nil true))

(define (nil-if-empty subject)
    (when (nil? (empty? subject)) subject))


# #############################################################################
# System & Search functions

;; (index predicate list)
(define (find-all-index keyword target)
    (let (found (list))
        (dolist (item target)
            (when (= item keyword)
                (push $idx found)))
        (sort found)))

(setq join-paths:SLASH (if (= ostype "Windows") "\\" "/"))
(define (join-paths:join-paths)
    (join (flat (args)) join-paths:SLASH))

;; ((file-name file), ..)
(define (load-files given-directory file-ending)
    (let (loaded '())
        (when (is and string? directory? given-directory)
            (dolist (file-name (sort (directory given-directory)))
                (let (file (join-paths given-directory file-name))
                    (when (and (file? file true) (ends-with file-name file-ending))
                        (push (list file-name (read-file file)) loaded -1)))))
        loaded))
