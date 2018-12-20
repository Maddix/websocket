(load "lib.lsp")
(load "byte-functions.lsp")
;(load "maskBytes.lsp")

(define (byte-to-int str)
	(integer (append "0b" str)))


(new Class 'Socket-Message)

(define (Socket-Message:populate-socket-message Socket-Message:message)
	; set FIN RSV OPCODE
	;(let (byte (raw-message (inc idx)))
	;	(body)
	;)
	(println Socket-Message:message "\n" (self))
	(self)
)

(define (Socket-Message:Socket-Message (Socket-Message:raw-bytes ""))
	(let (body
		(list Socket-Message
			(list
				(list 'raw-bytes raw-bytes)
				;; First Byte
				(list 'FIN nil)
				(list 'RSV '())
				(list 'OPCODE '())
				;; Second byte
				(list 'MASK nil)
				;; May take the next 4-8 bytes
				(list 'PAYLOAD-LEN nil)
				;; 4 bytes
				(list 'MASKING-KEYS '())
				;; The winning byte from MASKING-KEYS
				(list 'MASKING-KEY nil)
				;; The rest of the message unmasked o/c
				(list 'PAYLOAD '()))))
		; --
		(if (empty? raw-bytes)
			body
			(:populate-socket-message body raw-bytes)))) ;;(unpack-msg raw-bytes)))))


(context 'MAIN)
