(set-option :produce-models true)
(set-logic QF_LIA)

(define-fun max ((x Int) (y Int)) Int (ite (< x y) y x))

; Return the max value that is below top. If there isnt one, return 0
(define-fun gate ((top Int) (x Int)) Int (ite (< x top) x 0))
(define-fun max-below ((top Int) (x Int) (y Int)) Int
	(let ((m (max (gate top x) (gate top y))))
		(ite (< m top) m 0)))

; Calculates the maximum input sum that is below top
(define-fun max-val-below ((top Int)) Int
	(max-below top (+ 0{% for line in input_lines -%}
	{% if line == "" %})
	(max-below top (+ 0{% else %} {{ line }}{% endif %}
	{%- endfor %}) 0)
	{%- for line in input_lines if line == "" %}){%- endfor %})

(define-fun max-val () Int (max-val-below 1000000000000000000))
(define-fun second-val () Int (max-val-below max-val))
(define-fun third-val () Int (max-val-below second-val))

(define-fun part-1 () Int max-val)
(define-fun part-2 () Int (+ max-val second-val third-val))

(check-sat)
(get-value (part-1 part-2))
