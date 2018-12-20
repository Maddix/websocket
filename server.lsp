
(load "crypto.lsp")
(load "bitArray.lsp")
(load "byte-functions.lsp")

;;; HTTP/1.1 101 Switching Protocols
;;; Upgrade: websocket
;;; Connection: Upgrade
;;; Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=

;;; HTTP/1.1 101 Switching Protocols\r\n
;;; Upgrade: websocket\r\n
;;; Connection: Upgrade\r\n
;;; Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=\r\n
;;; \r\n

;; Send Hello World! to the client
;(net-send 4 (pack (dup "b" 14) (flat (list 0b10000001 0b00001100 (unpack (dup "b " 12) "Hello World!")))))

;; Send a ping to the client
;(net-send 4 (pack "bb" 0b10001001 0b00000000))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Open a connection and return the device key

(define (get-server-handshake-key client-key)
	(println "Client-key:" client-key)
	(base64-enc (crypto:sha1 (append client-key "258EAFA5-E914-47DA-95CA-C5AB0DC85B11") true)))

(define (get-handshake-response response-key)
	(append
		"HTTP/1.1 101 Switching Protocols\r\n"
		"Upgrade: websocket\r\n"
		"Connection: Upgrade\r\n"
		"Sec-WebSocket-Accept: " response-key "\r\n"
		"\r\n"))

(define (parse-http data)
	(map (fn (key-value) (parse key-value ": ")) (parse (trim data) "\n")))

(define (get-websocket-key http-data)
	(trim (last (assoc "Sec-WebSocket-Key" (parse-http http-data)))))

(define (get-connection port)
	(net-accept (net-listen port)))

(define (read-connection connection)
	(net-receive connection buf (net-peek connection))
	buf)

;;; (Will hang till something connects then it'll return a device which is normmally 4)
;;; (open-conn 8081) -> 4
(define (open-conn port)
	(let (connection (get-connection port))
		(sleep 1000)
		(net-send connection (get-handshake-response (get-server-handshake-key (get-websocket-key (read-connection connection)))))
		connection))

(define (close-sessions)
	(dolist (session (net-sessions))
		(when (net-close session) (println "Closed Session: " session))))
