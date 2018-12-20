
(import "c/maskBytes.so" "c_xorBytes")

(define (mask-bytes mask-byte byte-string)
	(map char (unpack (dup "c" (length byte-string)) (c_xorBytes mask-byte byte-string))))
