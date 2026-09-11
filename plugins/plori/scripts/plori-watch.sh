#!/bin/sh
# Background monitor for the plori Claude Code plugin.
#
# Prints one JSON line for every run on the account that finished or paused for
# a human answer. Claude Code delivers each stdout line to Claude as a
# notification. When the plori CLI is absent or has no credentials, this script
# writes one line to stderr and exits without printing anything to stdout.
#
# Requires the plori CLI 0.4.0 or later: curl -fsSL https://plori.ai/install.sh | sh

set -u

note() {
	printf 'plori monitor: %s\n' "$1" >&2
}

if ! command -v plori >/dev/null 2>&1; then
	note 'plori CLI not found on PATH. Install it with: curl -fsSL https://plori.ai/install.sh | sh'
	exit 0
fi

# Credential probe. Without --ack, plori inbox reads state and changes nothing.
# It exits 3 when the stored credentials are missing, rejected, or expired.
plori inbox >/dev/null 2>&1
probe_status=$?
if [ "$probe_status" -eq 3 ]; then
	note 'no plori credentials. Run: plori login'
	exit 0
fi

plori watch --events terminal,input
watch_status=$?

case "$watch_status" in
0) ;;
3) note 'plori credentials were rejected. Run plori login to restore run notifications.' ;;
4) note 'the plori control plane could not be reached. Run notifications stopped.' ;;
*) note "plori watch stopped with exit code ${watch_status}." ;;
esac

exit 0
