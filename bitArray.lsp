
(import "c/bitArray.so" "bitsToChars")

(define (bytes-to-char-list str)
	(when (string? str)
		(map char (unpack (dup "c" (* 8 (length str))) (bitsToChars str)))))
