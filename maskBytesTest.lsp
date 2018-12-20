#!/usr/bin/env newlisp
(load "maskBytes.lsp")

(setq
	mask "4"
	data "abc"
	result (mask-bytes mask data)
	mask-back-result (mask-bytes mask (join result))
	unpacked (apply unpack (extend (list "ccc") result)))

(println "\nMask: " mask)
(println "Data: " data)
(println "Result masked: " result)
(println "Result remasked: " mask-back-result)
(println "Unpacked: " unpacked)
(println "Map char: " (map char unpacked))

(exit)
