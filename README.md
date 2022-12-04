# AoC 2022

Attempting to do some of Advent of Code 2022 using smtlib (with jinja for
input templating). Don't think I will get very far as smtlib is awkward for
this but its kinda fun.

Solutions can be run with the following.
```bash
./template.py <day> | z3 -smt2 -in
```

## Some Python Code Golfing

### Day 1 Part 2
```python
print(sum(sorted(sum(map(int,l.split()))for l in open("1.txt").read().split("\n\n"))[-3:]))
```

### Day 3 part 2

```python
j="".join;print(sum(ord(s)-58*(s>'Z')-24for s in j(j(a&b&c)for a,b,c in zip(*(map(set,open("3.txt")),)*3))))
```
