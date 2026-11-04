#!/usr/bin/env python3
"""Waybar module showing dunst's do-not-disturb (paused) state.

Prints one JSON object per state change (waybar "return-type": "json").
Updates come from dunst's org.freedesktop.DBus.Properties.PropertiesChanged
signal, so there is no polling. Restarts of dunst are followed through
bus-name ownership: the state is re-read whenever the name reappears.
"""

import json

import gi

gi.require_version("Gio", "2.0")
from gi.repository import Gio, GLib  # noqa: E402

BUS_NAME = "org.freedesktop.Notifications"
OBJECT_PATH = "/org/freedesktop/Notifications"
DUNST_IFACE = "org.dunstproject.cmd0"
PROPERTIES_IFACE = "org.freedesktop.DBus.Properties"
CALL_TIMEOUT_MS = 2000

ICON_ACTIVE = "\U000F009A"  # nf-md-bell
ICON_PAUSED = "\U000F009B"  # nf-md-bell_off


def emit(text: str, css_class: str, tooltip: str) -> None:
    print(
        json.dumps(
            {"text": text, "class": css_class, "tooltip": tooltip},
            ensure_ascii=False,
        ),
        flush=True,
    )


def emit_paused(paused: bool) -> None:
    if paused:
        emit(ICON_PAUSED, "paused", "Do not disturb: on (click to turn off)")
    else:
        emit(ICON_ACTIVE, "active", "Do not disturb: off (click to turn on)")


def emit_unavailable(reason: str) -> None:
    emit(ICON_PAUSED, "unavailable", f"dunst unavailable: {reason}")


def on_properties_changed(_conn, _sender, _path, _iface, _signal, params, _data):
    iface, changed, _invalidated = params.unpack()
    if iface == DUNST_IFACE and "paused" in changed:
        emit_paused(changed["paused"])


def on_paused_read(conn: Gio.DBusConnection, result: Gio.AsyncResult) -> None:
    try:
        (value,) = conn.call_finish(result).unpack()
    except GLib.Error as err:
        # The name is owned, but not by dunst (or dunst is unresponsive).
        emit_unavailable(err.message)
        return
    emit_paused(value)


def on_name_appeared(conn: Gio.DBusConnection, _name: str, _owner: str) -> None:
    conn.call(
        BUS_NAME,
        OBJECT_PATH,
        PROPERTIES_IFACE,
        "Get",
        GLib.Variant("(ss)", (DUNST_IFACE, "paused")),
        GLib.VariantType("(v)"),
        Gio.DBusCallFlags.NONE,
        CALL_TIMEOUT_MS,
        None,
        on_paused_read,
    )


def on_name_vanished(_conn: Gio.DBusConnection, _name: str) -> None:
    emit_unavailable("not running")


def main() -> None:
    conn = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    # Subscribe before reading the initial state so no change can slip
    # between the read and the subscription.
    conn.signal_subscribe(
        BUS_NAME,
        PROPERTIES_IFACE,
        "PropertiesChanged",
        OBJECT_PATH,
        DUNST_IFACE,  # arg0 match: only dunst's own interface
        Gio.DBusSignalFlags.NONE,
        on_properties_changed,
        None,
    )
    Gio.bus_watch_name_on_connection(
        conn,
        BUS_NAME,
        Gio.BusNameWatcherFlags.NONE,
        on_name_appeared,
        on_name_vanished,
    )
    GLib.MainLoop().run()


if __name__ == "__main__":
    main()
