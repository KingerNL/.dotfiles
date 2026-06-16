#!/usr/bin/env python3
import re
import sys
from pathlib import Path


if len(sys.argv) != 2:
    raise SystemExit(2)

response_file = Path(sys.argv[1])
ansi_re = re.compile(r"\x1b\[[0-9;?]*[ -/]*[@-~]")
status_re = re.compile(r"^\s*>\s*(build|plan|ask|run)\s*(·|\.)?", re.IGNORECASE)

buffer = ""
pending = ""
line = ""
started = False


def write_buffer() -> None:
    response_file.write_text(buffer.strip() + "\n")


while True:
    chunk = sys.stdin.read(32)
    if chunk == "":
        break

    chunk = pending + chunk
    pending = ""

    esc = chunk.rfind("\x1b")
    if esc != -1 and not ansi_re.search(chunk[esc:]):
        pending = chunk[esc:]
        chunk = chunk[:esc]

    chunk = ansi_re.sub("", chunk).replace("\r", "")

    for char in chunk:
        line += char

        if char == "\n":
            clean_line = line.strip("\n")
            line = ""

            if status_re.match(clean_line) or not clean_line.strip():
                continue

            started = True
            buffer += clean_line + "\n"
            write_buffer()
            continue

        if started or line.strip():
            candidate = line
            if status_re.match(candidate):
                continue
            started = True
            response_file.write_text((buffer + candidate).strip() + "\n")

if line.strip() and not status_re.match(line):
    buffer += line

if buffer.strip():
    write_buffer()
else:
    response_file.write_text("No response.\n")
