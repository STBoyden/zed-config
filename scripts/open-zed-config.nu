#!/usr/bin/env nu

let editor_command: list<string> = ($env.EDITOR? | default ["zed"])

run-external ...$editor_command $"($env.HOME)/.config/zed"
