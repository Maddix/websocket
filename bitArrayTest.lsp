#!/usr/bin/env newlisp
(load "bitArray.lsp")

(define (bits-to-bytes bit-lst)
	(let (rows '())
		(dotimes (idx (div (length bit-lst) 8))
			(push ((* idx 8) 8 bit-lst) rows))))

(setf
	hello "Hello World!"
	data (bytes-to-char-list hello))

(dolist (lst (bits-to-bytes data))
	(println (join lst) " : " (hello $idx)))

(exit)
