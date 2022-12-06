(set-option :produce-models true)
(set-logic QF_UFBV)

{%- set chars = "abcdefghijklmnopqrstuvwxyz" %}
{% for char in chars %}
(declare-const {{ char }} (_ BitVec 5))
{%- endfor %}
(assert (distinct #b00000 {{ " ".join(chars) }}))

(declare-sort State 0)
{% for i in range(14) %}
(declare-fun get-arr-{{ i }} (State) (_ BitVec 5))
{%- endfor %}
(declare-fun get-count (State) (_ BitVec 12))
(declare-fun get-result-4 (State) (_ BitVec 12))
(declare-fun get-result-14 (State) (_ BitVec 12))

(define-fun init ((state State)) Bool
	(and
		(= (get-count state) #x000)
		(= (get-result-4 state) #x000)
		(= (get-result-14 state) #x000)))

(define-fun exec-arr ((state State) (next-state State) (input (_ BitVec 5))) Bool
	(and
		(= (get-arr-0 next-state) input)
		{%- for i in range(1, 14) %}
		(= (get-arr-{{ i }} next-state) (get-arr-{{ i - 1 }} state))
		{%- endfor %}))

(define-fun next-count ((state State)) (_ BitVec 12)
	(bvadd (get-count state) #x001))

{% for count in (4, 14) %}
(define-fun sop-{{ count }} ((state State)) Bool
	(distinct
		{%- for i in range(count) %}
		(get-arr-{{ i }} state)
		{%- endfor %}))

(define-fun next-result-{{ count }} ((state State)) (_ BitVec 12)
	(let ((result (get-result-{{ count }} state)))
	(ite (and (= result #x000) (sop-{{ count }} state)) (get-count state) result)))
{% endfor %}

(define-fun exec ((state State) (next-state State) (input (_ BitVec 5))) Bool
	(and
		(exec-arr state next-state input)
		(= (get-count next-state) (next-count state))
		(= (get-result-4 next-state) (next-result-4 state))
		(= (get-result-14 next-state) (next-result-14 state))))

(declare-const s0 State) (assert (init s0))
{% for c in input_lines[0] %}
(declare-const s{{ loop.index }} State) (assert (exec s{{ loop.index - 1 }} s{{ loop.index }} {{ c }}))
{%- endfor %}

(define-fun part-1 () (_ BitVec 12) (get-result-4 s{{ len(input_lines[0])}}))
(define-fun part-2 () (_ BitVec 12) (get-result-14 s{{ len(input_lines[0])}}))
(assert (bvult #x003 part-1))
(assert (bvult #x003 part-2))

(check-sat)
(get-value (part-1 part-2))
