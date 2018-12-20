
;; Unpack a number/character(?) into a list of bits (18 -> (0 0 0 1 0 0 1 0))
(define (int->byte number)
	(let (byte '())
		(for (idx 0 7)
			(push
				(if (zero? (& number (<< 1 idx))) 0 1) byte))))


;; Unpack a byte string of type byte-type into a list
(define (unpack-msg byte-string (byte-type "b"))
	(unpack (dup byte-type (length byte-string)) byte-string))
