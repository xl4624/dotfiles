#!/usr/bin/env python3
"""Show a notification whenever the ACPI platform profile changes.

The ThinkPad "Mode" key (F8) cycles the profile inside the kernel, so this
is used to notify when the mode changes and what it changes to
"""

import select
import subprocess
import sys

PROFILE_PATH = "/sys/firmware/acpi/platform_profile"
STACK_TAG = "power-profile"


def read_profile(f) -> str:
    f.seek(0)
    return f.read().strip()


def notify(profile: str) -> None:
    subprocess.run(
        [
            "notify-send",
            "--app-name=Power profile",
            "--urgency=low",
            f"--hint=string:x-dunst-stack-tag:{STACK_TAG}",
            "Power profile",
            profile,
        ],
        check=False,
    )


def main() -> int:
    try:
        f = open(PROFILE_PATH)
    except OSError as e:
        print(f"power-profile-notify: cannot open {PROFILE_PATH}: {e}", file=sys.stderr)
        return 1

    with f:
        poller = select.poll()
        poller.register(f, select.POLLPRI | select.POLLERR)
        current = read_profile(f)  # also arms the next poll() wakeup
        while True:
            poller.poll()
            profile = read_profile(f)
            if profile != current:
                current = profile
                notify(profile)


if __name__ == "__main__":
    sys.exit(main())
