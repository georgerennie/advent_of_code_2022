(set-option :produce-models true)
(set-logic LIA)

; Part 1

; Assumes that low is lower than high
(declare-datatype Range
	((range (low Int) (high Int)))
)

(define-fun in-range ((i Int) (range Range)) Bool
	(and (>= i (low range)) (<= i (high range)))
)

; Returns true if inner is fully contained by outer
(define-fun contains ((inner Range) (outer Range)) Bool
	(and (in-range (low inner) outer) (in-range (high inner) outer))
)

(define-fun either-contains ((a Range) (b Range)) Bool
	(or (contains a b) (contains b a))
)

; Convert to int for simplicity
(define-fun either-contains-i ((a Range) (b Range)) Int
	(ite (either-contains a b) 1 0)
)

(define-fun part-1 () Int
	(+
		{%- for line in input_lines %}
		(either-contains-i{% for elf in line.split(",") %} (range{% for n in elf.split("-") %} {{ n }}{% endfor %}){% endfor %})
		{%- endfor %}
	)
)

; Part 2

(define-fun overlaps ((a Range) (b Range)) Bool
	(or
		(in-range (low  a) b)
		(in-range (high a) b)
		(in-range (low  b) a)
		(in-range (high b) a)
	)
)

; Convert to int for simplicity
(define-fun overlaps-i ((a Range) (b Range)) Int
	(ite (overlaps a b) 1 0)
)

(define-fun part-2 () Int
	(+
		{%- for line in input_lines %}
		(overlaps-i{% for elf in line.split(",") %} (range{% for n in elf.split("-") %} {{ n }}{% endfor %}){% endfor %})
		{%- endfor %}
	)
)

(check-sat)
(get-value (part-1 part-2))
