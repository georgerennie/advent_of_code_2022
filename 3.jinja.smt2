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
(declare-const line_{{ loop.index }} (_ BitVec 16))
(assert (= (oh line_{{ loop.index }}) (bvand
	(bvor {{ " ".join(line[:len(line)//2]) }})
	(bvor {{ " ".join(line[len(line)//2:]) }})
)))
{% endfor %}

(define-fun part_1 () (_ BitVec 16)
	(bvadd {%- for line in input_lines %} line_{{ loop.index }}{%- endfor %})
)

; Part 2

{% for chunk in chunks(input_lines, 3) %}
(declare-const group_{{ loop.index }} (_ BitVec 16))
(assert (= (oh group_{{ loop.index }}) (bvand
	{%- for line in chunk %}
	(bvor {{ " ".join(line) }})
	{%- endfor %}
)))
{% endfor %}

(define-fun part_2 () (_ BitVec 16)
	(bvadd {%- for chunk in chunks(input_lines, 3) %} group_{{ loop.index }}{%- endfor %})
)

(check-sat)
(get-value (part_1 part_2))
