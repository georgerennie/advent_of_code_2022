(set-option :produce-models true)
(set-logic QF_LIA)

(define-fun max ((x Int) (y Int)) Int (ite (< x y) y x))

; Return the max value that is below top. If there isnt one, return 0
(define-fun gate ((top Int) (x Int)) Int (ite (< x top) x 0))
(define-fun max_below ((top Int) (x Int) (y Int)) Int
	(let ((m (max (gate top x) (gate top y))))
		(ite (< m top) m 0))
)

; Calculates the maximum input sum that is below top
(define-fun max_val_below ((top Int)) Int
	(max_below top (+ 0{% for line in input_lines -%}
	{% if line == "" %})
	(max_below top (+ 0{% else %} {{ line }}{% endif %}
	{%- endfor %}) 0)
	{% for line in input_lines if line == "" %})
	{%- endfor %}
)

(define-fun max_val () Int (max_val_below 1000000000000000000))
(define-fun second_val () Int (max_val_below max_val))
(define-fun third_val () Int (max_val_below second_val))

(define-fun part_1 () Int max_val)
(define-fun part_2 () Int (+ max_val second_val third_val))

(check-sat)
(get-value (part_1 part_2))
