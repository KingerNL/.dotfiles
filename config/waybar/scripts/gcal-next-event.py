#!/usr/bin/env python3

import datetime as dt
import html
import json
import os
import re
import shutil
import subprocess
import sys


GCALCLI = shutil.which("gcalcli") or os.path.expanduser("~/.local/bin/gcalcli")


def waybar(text, tooltip=None, css_class=None):
    payload = {"text": html.escape(text), "tooltip": html.escape(tooltip or text)}
    if css_class:
        payload["class"] = css_class
    print(json.dumps(payload, ensure_ascii=False))


def strip_ansi(value):
    return re.sub(r"\x1b\[[0-9;]*m", "", value)


def parse_tsv_event(line):
    parts = [part.strip() for part in line.split("\t")]
    if len(parts) < 5 or parts[0] == "start_date":
        return None

    start_date, start_time, end_date, end_time, title = parts[:5]
    return {
        "start_date": start_date,
        "start_time": start_time,
        "end_date": end_date,
        "end_time": end_time,
        "title": title,
    }


def format_event(event, include_date=False):
    start_date = event["start_date"]
    start_time = event["start_time"]
    end_time = event["end_time"]
    title = event["title"]
    today = dt.date.today().isoformat()
    if start_time and end_time:
        time_range = f"{start_time} - {end_time}"
    elif start_time:
        time_range = start_time
    else:
        time_range = "All day"

    if not include_date:
        if start_date == today:
            return f"{title} {time_range}"

        if start_date == (dt.date.today() + dt.timedelta(days=1)).isoformat():
            return f"{title} Tomorrow {time_range}"

        return f"{title} {start_date} {time_range}"

    if start_date == today:
        date_label = "Today"
    elif start_date == (dt.date.today() + dt.timedelta(days=1)).isoformat():
        date_label = "Tomorrow"
    else:
        date_label = start_date

    return f"{date_label} {time_range}  {title}"


def event_from_tsv(line):
    event = parse_tsv_event(line)
    if not event:
        return None

    return format_event(event)


def tooltip_from_events(events):
    if not events:
        return "No upcoming Google Calendar events"

    lines = ["Upcoming events"]
    for index, event in enumerate(events[:10], start=1):
        lines.append(f"{index}. {format_event(event, include_date=True)}")

    return "\n".join(lines)


def text_events_from_output(output):
    events = []
    for line in output.splitlines():
        if "\t" in line:
            event = parse_tsv_event(line)
            if event:
                events.append(event)
        else:
            text = event_from_text(line)
            if text:
                today = dt.date.today().isoformat()
                events.append({
                    "start_date": today,
                    "start_time": "",
                    "end_date": today,
                    "end_time": "",
                    "title": text,
                })

    return events


def event_from_text(line):
    line = strip_ansi(line).strip()
    if not line or line.startswith("+") or line.startswith("|"):
        return None
    if line.lower().startswith(("not yet authenticated", "starting auth flow", "note:")):
        return None
    return " ".join(line.split())


def legacy_event_from_tsv(line):
    parts = [part.strip() for part in line.split("\t")]
    if len(parts) < 5 or parts[0] == "start_date":
        return None

    start_date, start_time, end_date, end_time, title = parts[:5]
    today = dt.date.today().isoformat()
    time_range = f"{start_time} - {end_time}" if end_time else start_time

    if start_date == today:
        return f"{title} {time_range}"

    if start_date == (dt.date.today() + dt.timedelta(days=1)).isoformat():
        return f"{title} Tomorrow {time_range}"

    return f"{title} {start_date} {time_range}"


def main():
    if not os.path.exists(GCALCLI):
        waybar("󰃭 gcal missing", "Install gcalcli first", "setup")
        return

    end = (dt.datetime.now() + dt.timedelta(days=14)).strftime("%Y-%m-%d")
    command = [
        GCALCLI,
        "agenda",
        "--nocolor",
        "--nodeclined",
        "--nostarted",
        "--military",
        "--tsv",
        "now",
        end,
    ]

    try:
        result = subprocess.run(command, text=True, capture_output=True, timeout=20, check=False)
    except subprocess.TimeoutExpired:
        waybar("󰃭 timeout", "gcalcli timed out", "error")
        return

    combined = "\n".join([result.stdout, result.stderr])
    if "Not yet authenticated" in combined or "Client ID:" in combined or "EOF when reading" in combined:
        waybar("󰃭 auth", "Run gcalcli auth setup with your Google OAuth client ID/secret", "setup")
        return

    if result.returncode != 0:
        waybar("󰃭 error", strip_ansi(combined).strip() or "gcalcli failed", "error")
        return

    events = text_events_from_output(result.stdout)
    if events:
        event = format_event(events[0])
        waybar(f"󰃭  {event} ", tooltip_from_events(events))
        return

    waybar("󰃭 none", "No upcoming Google Calendar events", "empty")


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError:
        sys.exit(0)
