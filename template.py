#! /usr/bin/env python3

import jinja2, argparse, sys
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("day", help="print the templated output for this day", type=int)
args = parser.parse_args()

input_path = Path("input", str(args.day)).with_suffix(".txt")
with open(input_path, "r") as f:
    input_lines = list(f.read().splitlines())

template_path = Path(str(args.day)).with_suffix(".jinja.smt2")
with open(template_path, "r") as f:
    template = jinja2.Template(f.read())

    def chunks(lst, n):
        """Yield successive n-sized chunks from lst."""
        for i in range(0, len(lst), n):
            yield lst[i : i + n]

    smt = template.render(
        input_lines=input_lines, len=len, chunks=chunks, ord=ord, set=set
    )
    print(smt)
