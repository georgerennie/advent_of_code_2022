(set-option :produce-models true)
(set-logic QF_UFBV)

; Part 1

(define-fun oh ((val (_ BitVec 16))) (_ BitVec 52)
	(bvshl #x0000000000001 (concat #x000000000 (bvsub val #x0001)))
)

{% for c in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" %}
(define-fun {{ c }} () (_ BitVec 52) (oh {{ "#x%04x" % loop.index }}))
{%- endfor %}

{% for line in input_lines -%}
(declare-const line-{{ loop.index }} (_ BitVec 16))
(assert (= (oh line-{{ loop.index }}) (bvand
	(bvor {{ " ".join(line[:len(line)//2]) }})
	(bvor {{ " ".join(line[len(line)//2:]) }})
)))
{% endfor %}

(define-fun part-1 () (_ BitVec 16)
	(bvadd {%- for line in input_lines %} line-{{ loop.index }}{%- endfor %})
)

; Part 2

{% for chunk in chunks(input_lines, 3) %}
(declare-const group-{{ loop.index }} (_ BitVec 16))
(assert (= (oh group-{{ loop.index }}) (bvand
	{%- for line in chunk %}
	(bvor {{ " ".join(line) }})
	{%- endfor %}
)))
{% endfor %}

(define-fun part-2 () (_ BitVec 16)
	(bvadd {%- for chunk in chunks(input_lines, 3) %} group-{{ loop.index }}{%- endfor %})
)

(check-sat)
(get-value (part-1 part-2))
